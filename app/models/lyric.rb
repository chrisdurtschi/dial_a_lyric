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

  def self.search(params)
    if params[:artist_query]
      search_for_artist params[:artist_query]
    elsif params[:artist_url]
      get_artist params[:artist_url]
    elsif params[:album_url]
      get_album params[:album_url]
    end
  end

  def self.search_for_artist(query)
    url = "#{LYRIC_URL}/search.php"
    res = RestClient.get url, :params => { :section => 'search', :searchW => query, :searchIn1 => 'artist' }
    doc = Nokogiri::HTML res.body

    artists = []
    doc.css('.inner-box-4-content > ul > li').each do |node|
      name = node.text.strip.sub(/ Lyrics$/, '')
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
      case node.at_css('.inner-box-2-title').text.strip
      when 'Albums'
        current = albums
      when 'Songs'
        current = songs
      end

      node.css('.inner-box-2-content > ol > li').each do |item|
        name = item.text.strip.sub(/ Lyrics$/, '')
        url  = item.at('a')['href']
        current << { name: name, url: url }
      end
    end
    { :albums => albums, :songs => songs }
  end

  def self.get_album(url)
    res = RestClient.get url
    doc = Nokogiri::HTML res.body

    songs = []
    doc.css('.album-ringtones-box-top-content > ol > li').each do |node|
      name = node.text.strip.sub(/ Lyrics$/, '')
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

    details = []
    doc.css('.album-details-container > .middle > code').each do |node|
      details << node.text
    end
    self.title, self.artist, self.album = details

    lines = doc.at_css('p#songLyricsDiv').text.split("\n")
    lines.map! do |line|
      line.sub /\[ .* www\.songlyrics\.com \] /, ''
    end
    lines.map!(&:strip)
    lines.reject!(&:blank?)
    self.body = lines.join("\n")
  end
end
