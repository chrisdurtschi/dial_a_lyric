class LyricsController < ApplicationController
  def search
    @search = Lyric.search(params)
  end

  def show
    @lyric = Lyric.find(params[:id])
  end
end
