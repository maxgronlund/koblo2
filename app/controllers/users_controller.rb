class UsersController < ApplicationController

  before_filter :require_admin, :only => :index

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id] || current_user.id)
    @connections_count = Follow.count_for_user(@user)
    @follows = Follow.for_user(@user, 1, 16)
    @activities = Activity.where(:user_id => @user.all_following).paginate(:per_page => 10, :page => (params[:page] || 1))
  end

end
