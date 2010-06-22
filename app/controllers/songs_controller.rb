class SongsController < ApplicationController

  def create
    tracks_attributes = params[:song].delete(:tracks_attributes)
    @song = current_user.songs.create(params[:song])
    @song.duration = 100
    tracks_attributes.each do |track_attributes|
      track = Track.find(track_attributes.delete(:id))
      track.update_attributes(track_attributes)
      @song.tracks << track
    end

    respond_to do |format|
      if @song.save
        redirect_to user_path(current_user)        
      else
        format.html { render :action => "new" }
      end
    end
  end

end
