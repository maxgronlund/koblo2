class SongsController < ApplicationController

  before_filter :authenticate_user!, :only => [:create, :destroy]
  before_filter :simple_authenticate, :only => :index
  
  before_filter :sidebar_for_user, :only => :new
  before_filter :sidebar_for_frontpage, :except => [:index, :new]
  layout 'frontpage_content', :except => [:index, :new]

  def simple_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "koblo" && password == "demo4"
    end
    warden.custom_failure! if performed?
  end

  def index
    pagination_options = {
      :page => (params[:page] || 1),
      :per_page => 10
    }

    user_content = false
    if params[:user_id] 
      user_content = true
      sidebar_for_user
      @songs = @user.songs.paginate(pagination_options)
    end

    if params[:q]
      @artists = User.search(params[:q]).first(5).paginate(pagination_options)
      @songs = Song.search(params[:q]).first(5).paginate(pagination_options)
    elsif params[:user_id] 
      @songs = @user.songs.paginate(pagination_options)
    elsif params[:category_id]
      @songs = Song.where(:category_id => params[:category_id]).paginate(pagination_options)
    else
      scope = %w{newest most_downloaded}.include?(params[:scope]) ? params[:scope] : 'best'
      if scope == 'best'
        @songs = Song.paginate(pagination_options.merge({:joins => 'LEFT JOIN ratings ON ratings.song_id = songs.id', :group => 'songs.id', :order => 'AVG(ratings.value) DESC'}))
      else
        @songs = Song.send(scope).paginate(pagination_options)
      end
    end
    
    if (user_content)
      content_layout = 'user_content'
    else
      sidebar_for_frontpage
      content_layout = 'frontpage_content'
    end

    respond_to do |format|
      format.html { render :index, :layout => content_layout }
      format.xml { render :partial => 'songs/songs' }
    end
  end

  def new
    render :layout => 'user_content'
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
      redirect_to share_song_path(@song)
    else
      render :action => "new" 
    end
  end

  def buy
    @song = Song.find_by_id(params[:id])
  end

  def share
    @song = Song.find_by_id(params[:id])
  end

  def studio
    @song = Song.find_by_id(params[:id])
  end
  
  def show
    @songs = [Song.find(params[:id])]
    respond_to do |format|
      format.html
      format.xml { render '/home/index' }
    end
  end

end
