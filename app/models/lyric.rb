class Lyric < ActiveRecord::Base
  LYRIC_URL = "http://www.songlyrics.com"

  validates_presence_of :url, :body

  before_validation :get_body

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
      name = node.text.strip
      link = node.at('a')['href']
      artists << { name: name, link: link }
    end
    artists
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
        name = item.text.strip
        link = item.at('a')['href']
        current << { name: name, link: link }
      end
    end
    {:albums => albums, :songs => songs}
  end

  def self.get_album(url)
    res = RestClient.get url
    doc = Nokogiri::HTML res.body

    songs = []
    doc.css('.album-ringtones-box-top-content > ol > li').each do |node|
      name = node.text.strip
      link = node.at('a')['href']
      songs << { name: name, link: link }
    end
    songs
  end

protected

  def get_body
    return if url.blank?
    res = RestClient.get url
    doc = Nokogiri::HTML res.body

    lines = doc.at_css('p#songLyricsDiv').text.split("\n")
    lines.map!(&:strip)
    lines.reject!(&:blank?)
    lines.map! do |line|
      line.sub /\[ The .* are found on www.songlyrics.com \] /, ''
    end
    self.body = lines.join("\n")
  end
end
