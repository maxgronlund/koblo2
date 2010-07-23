class HomeController < ApplicationController

  def index
    if user_signed_in? && !params[:redirect]
      redirect_to user_path(current_user)
    else
      redirect_to songs_path(:scope => 'best')
    end
  end

end
