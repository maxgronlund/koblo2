class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => :index

  def index
    if params[:q].blank?
      scope = %w{best newest most_downloaded}.include?(params[:scope]) ? params[:scope] : 'best'
      @songs = Song.send(scope).paginate :page => (params[:page] || 1), :per_page => 5
    else
      @songs = Song.search_for(params[:q]).best.paginate :page => (params[:page] || 1), :per_page => 5
    end
  end

end
