class ConnectionsController < ApplicationController

  before_filter :authenticate_user!, :only => [:create, :destroy]

  before_filter :sidebar_for_user, :only => :index
  layout 'user_content', :only => :index

  def index
    @user = User.find_by_id(params[:user_id])
    set_follows
  end

  def create
    @user = User.find_by_id(params[:id])
    current_user.follow(@user)
    if params[:from] == 'connections'
      @user = current_user
      set_follows
    end
    respond_to do |format|
      format.html { user_path(@user) }
      format.js
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    current_user.stop_following(@user)
    if params[:from] == 'connections'
      @user = current_user
      set_follows
    end
    respond_to do |format|
      format.html { user_path(@user) }
      format.js
    end
  end

  private
  def set_follows
    per_page = 9
    page = params[:page].blank? ? 1 : params[:page].to_i
    @follows = Follow.for_user(@user, page, per_page)
  end
end
