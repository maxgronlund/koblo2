class UsersController < ApplicationController

  before_filter :require_admin, :only => :index

  def index
    @users = User.all
  end

  def show
  end

end
