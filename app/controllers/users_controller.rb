class UsersController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    unless params[:record_label_id].blank?
      @users = User.where(:record_label_id => params[:record_label_id])
    else
      @users = User.all
    end
    @users = @users.paginate(:per_page => 10, :page => (params[:page] || 1))
  end

  def show
    @user = User.find_by_id(params[:id] || current_user.id)
    @connections_count = Follow.count_for_user(@user)
    @follows = Follow.for_user(@user, 1, 16)
    @activities = Activity.where(:user_id => @user.all_following).paginate(:per_page => 10, :page => (params[:page] || 1))
  end

end
