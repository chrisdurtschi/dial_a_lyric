class LyricsController < ApplicationController
  def search
    @search = Lyric.search(params)
  end
end
