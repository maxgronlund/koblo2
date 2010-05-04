class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    text = "Welcome "
    text += current_user.email if current_user
    render :text => text
  end

end
