class ConnectionsController < ApplicationController

  def index
    @user = User.find_by_id(params[:user_id])
    @follows = Follow.for_user(@user).paginate(:per_page => 9, :page => (params[:page] || 1))
  end
end
