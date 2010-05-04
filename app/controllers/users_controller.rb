class UsersController < ApplicationController

  before_filter :require_admin, :only => :index

  def index
    @user = User.all
  end

end
