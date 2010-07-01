class HomeController < ApplicationController

  def index
    redirect_to songs_path(:scope => 'best')
  end

end
