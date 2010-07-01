class SongsController < ApplicationController

  before_filter :authenticate_user!, :only => [:create, :destroy]
  
  before_filter :sidebar_for_user, :only => :new
  layout 'user_content', :only => :new

  def index
    user_content = false
    if params[:user_id] 
      user_content = true
      @songs = @user.songs.paginate(:per_page => 10, :page => (params[:page] || 1))
    end

    if params[:q]
      @songs = Song.search_for(params[:q]).best.paginate :page => (params[:page] || 1), :per_page => 5
    elsif params[:user_id] 
      @songs = @user.songs.paginate(:per_page => 10, :page => (params[:page] || 1))
    elsif params[:category_id]
      @songs = Song.where(:category_id => params[:category_id]).paginate(:per_page => 10, :page => (params[:page] || 1))
    else
      scope = %w{best newest most_downloaded}.include?(params[:scope]) ? params[:scope] : 'best'
      @songs = Song.send(scope).paginate :page => (params[:page] || 1), :per_page => 5
    end
    
    if (user_content)
      sidebar_for_user
      content_layout = 'user_content'
    else
      sidebar_for_frontpage
      content_layout = 'frontpage_content'
    end

    respond_to do |format|
      format.html { render :index, :layout => content_layout }
      format.xml
    end
  end

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
  
  def show
    @songs = [Song.find(params[:id])]
    respond_to do |format|
      format.html
      format.xml { render '/home/index' }
    end
  end

end
