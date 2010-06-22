class SongsController < ApplicationController

  def create
    tracks_attributes = params[:song].delete(:tracks_attributes)
    @song = current_user.songs.create(params[:song])
    @song.duration = 100
    tracks_attributes.each do |track_attributes|
      track = Track.find(track_attributes.delete(:id))
      track.update_attributes(track_attributes)
      @song.tracks << track
    end if tracks_attributes

    if @song.save
      redirect_to share_path(:user_id => params[:user_id], :song_id => @song.id) 
    else
      render :action => "new" 
    end
  end

  def share
    @song = Song.find_by_id(params[:song_id])
  end

end
