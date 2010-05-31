class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    @songs = Song.best.paginate :page => (params[:page] || 1), :per_page => 5
  end

end
