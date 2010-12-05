class LyricsController < ApplicationController
  def search
    results = Lyric.search(params)
    respond_to do |format|
      format.json { render :json => results }
    end
  end
end
