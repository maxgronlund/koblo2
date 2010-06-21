class SongsController < ApplicationController

  def create
    @song = current_user.songs.build(params[:song])

    respond_to do |format|
      if @song.save
        format.html
      else
        format.html { render :action => "new" }
      end
    end
  end

end
