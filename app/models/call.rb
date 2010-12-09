class Call < ActiveRecord::Base
  attr_accessor :lyric_url

  belongs_to :lyric

  validates_presence_of :from_name, :from_number, :to_name, :to_number, :voice, :lyric
  validates_presence_of :lyric_url, :on => :create
  validates_format_of :from_number, :to_number, :with => /^\d\d\d\d\d\d\d\d\d\d$/, :message => "must be a 10 digit phone number", :allow_blank => true

  before_validation :get_lyric
  before_validation :strip_numbers
  after_create :create_tropo_session

  VOICES = [
    ['US English - Female', 'allison'],
    ['US English - Male', 'dave'],
    ['British English - Female', 'kate'],
    ['British English - Male', 'simon'],
    ['Castilian Spanish - Female', 'carmen'],
    ['Castilian Spanish - Male', 'jorge'],
    ['Mexican Spanish - Female', 'soledad'],
    ['Mexican Spanish - Male', 'carlos'],
    ['French - Female', 'florence'],
    ['French - Male', 'bernard'],
    ['German - Female', 'katrin'],
    ['German - Male', 'stefan'],
    ['Italian - Female', 'paola'],
    ['Italian - Male', 'luca'],
    ['Dutch - Female', 'saskia'],
    ['Dutch - Male', 'willem'],
    ['Polish - Female', 'zosia'],
    ['Polish - Male', 'krzysztof']
  ]

protected

  def get_lyric
    self.lyric = Lyric.find_or_create lyric_url
  end

  def strip_numbers
    self.from_number = self.from_number.strip.gsub(/\D/, '') if self.from_number
    self.to_number = self.to_number.strip.gsub(/\D/, '') if self.to_number
  end

  def create_tropo_session
    token = ENV['TROPO_VOICE_TOKEN']
    RestClient.get "http://api.tropo.com/1.0/sessions", :params => { :action => 'create', :token => token, :call_id => self.id }
  end
end
