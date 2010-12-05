class Call < ActiveRecord::Base
  attr_accessor :lyric_url

  belongs_to :lyric

  validates_presence_of :name, :number, :lyric
  validates_format_of :number, :with => /^\d\d\d\d\d\d\d\d\d\d$/, :message => "must be a 10 digit phone number"

  before_validation :get_lyric
  after_create :create_tropo_session

protected

  def get_lyric
    self.lyric = Lyric.find_or_create lyric_url
  end

  def create_tropo_session
    token = ENV['TROPO_VOICE_TOKEN']
    RestClient.get "http://api.tropo.com/1.0/sessions", :params => { :action => 'create', :token => token, :call_id => self.id }
  end
end
