class UsersController < ApplicationController

  before_filter :require_admin, :only => :index

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id] || current_user.id)
    @connections_count = Follow.for_user(@user).count[@user.id]
    @follows = Follow.for_user(@user).first(16)
  end

end
