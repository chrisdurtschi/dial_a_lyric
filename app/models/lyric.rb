class Lyric < ActiveRecord::Base
  LYRIC_URL = "http://www.songlyrics.com"

  validates_presence_of :url, :title, :artist, :album, :body

  before_validation :parse_url

  def self.find_or_create(url)
    lyric = find_by_url(url)
    unless lyric
      lyric = Lyric.create :url => url
    end
    lyric
  end

  def self.search(query)
    return unless query
    url = "#{LYRIC_URL}/index.php"
    res = RestClient.get url, :params => {
      :section => 'search',
      :searchW => query,
      :searchIn1 => 'artist',
      :searchIn2 => 'album',
      :searchIn3 => 'song',
      :searchIn4 => 'lyrics'
    }
    doc = Nokogiri::HTML res.body

    songs = []
    doc.css('div.serpresult').each do |node|
      artist = node.at('h3 a').content
      name   = node.at('div.serpdesc-2 a:first').content.sub('Song: ', '')
      album  = node.at('div.serpdesc-2 a:last').content.sub('Album: ', '')
      url    = node.at('div.serpdesc-2 a:first')['href']
      songs << { artist: artist, name: name, album: album, url: url }
    end
    { songs: songs }
  end

  def self.search_for_artist(query)
    url = "#{LYRIC_URL}/search.php"
    res = RestClient.get url, :params => { :section => 'search', :searchW => query, :searchIn1 => 'artist' }
    doc = Nokogiri::HTML res.body

    artists = []
    doc.css('.inner-box-4-content > ul > li').each do |node|
      name = node.text.toutf8.strip.sub(/ Lyrics$/, '')
      url  = node.at('a')['href']
      artists << { name: name, url: url }
    end
    { :artists => artists }
  end

  def self.get_artist(url)
    res = RestClient.get url
    doc = Nokogiri::HTML res.body

    albums = []
    songs  = []
    doc.css('.inner-box-2').each do |node|
      case node.at_css('.inner-box-2-title').text.toutf8.strip
      when 'Albums'
        current = albums
      when 'Songs'
        current = songs
      end

      node.css('.inner-box-2-content > ol > li').each do |item|
        name = item.text.toutf8.strip.sub(/ Lyrics$/, '')
        a    = item.at('a')
        url  = a ? a['href'] : nil
        current << { name: name, url: url } if url
      end
    end
    { :albums => albums, :songs => songs }
  end

  def self.get_album(url)
    res = RestClient.get url
    doc = Nokogiri::HTML res.body

    songs = []
    doc.css('.album-ringtones-box-top-content > ol > li').each do |node|
      name = node.text.toutf8.strip.sub(/ Lyrics$/, '')
      url  = node.at('a')['href']
      songs << { name: name, url: url }
    end
    { :songs => songs }
  end

protected

  def parse_url
    return if url.blank?
    res = RestClient.get url
    doc = Nokogiri::HTML res.body

    self.artist = doc.at('div.pagetitle p:first a').content
    self.title  = doc.at('div.pagetitle h1').content.sub("#{artist} - ", '').sub(' Lyrics', '')
    self.album  = doc.at('div.pagetitle p:last a').content.sub(' Album Lyrics', '')

    lines = doc.at_css('p#songLyricsDiv').text.toutf8.split("\n")
    lines.map! do |line|
      line.sub /\[ .* www\.songlyrics\.com \] /, ''
    end
    lines.map!(&:strip)
    lines.reject!(&:blank?)
    self.body = lines.join("\n")
  end
end
