class LyricsController < ApplicationController
  def search
    respond_to do |format|
      format.json { render :json => Lyric.search(params) }
    end
  end
end
