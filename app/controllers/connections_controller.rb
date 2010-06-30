class ConnectionsController < ApplicationController

  def index
    @user = User.find_by_id(params[:user_id])
    @follows = Follow.for_user(@user).paginate(:per_page => 9, :page => (params[:page] || 1))
  end

  def create
    @user = User.find_by_id(params[:id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { user_path(@user) }
      format.js
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    current_user.stop_following(@user)
    respond_to do |format|
      format.html { user_path(@user) }
      format.js
    end
  end
end
