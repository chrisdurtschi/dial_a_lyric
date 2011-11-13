class CallsController < ApplicationController
  def new
    @call = Call.new(params[:call])
  end

  def create
    @call  = Call.new(params[:call])
    if @call.save
      flash[:notice] = "Call created"
      redirect_to @call
    else
      render :new
    end
  end

  def show
    @call = Call.find(params[:id])
  end

  def initiate
    v = Tropo::Generator.parse request.env["rack.input"].read
    t = Tropo::Generator.new

    call_id = v[:session][:parameters][:call_id].to_i
    call = Call.find(call_id)

    t.call :to => "#{call.to_number_country_prefix}#{call.to_number}", :from => "#{call.from_number_country_prefix}#{call.from_number}", :channel => 'VOICE', :required => true
    t.say :value => "Hello #{call.to_name}", :voice => call.voice
    t.say :value => "#{call.from_name} thought you would like this song", :voice => call.voice
    t.say :value => "The song is #{call.lyric.title} by #{call.lyric.artist} from the album #{call.lyric.album}", :voice => call.voice
    call.lyric.body.split("\n").each do |line|
      t.say :value => line, :voice => call.voice
    end

    respond_to do |format|
      format.json { render :json => t.response }
    end
  end
end
