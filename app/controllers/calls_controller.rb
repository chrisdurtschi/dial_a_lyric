class CallsController < ApplicationController
  def new
    @lyric = Lyric.new
    @call  = Call.new
  end

  def create
    @lyric = Lyric.new(params[:lyric])
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

    t.call :to => "+1#{call.to_number}", :from => "+1#{call.from_number}", :channel => 'VOICE', :required => true
    t.say :value => "Hello #{call.to_name}"
    t.say :value => "#{call.from_name} thought you would like this song"
    call.lyric.body.split("\n").each do |line|
      t.say :value => line
    end

    respond_to do |format|
      format.json { render :json => t.response }
    end
  end
end
