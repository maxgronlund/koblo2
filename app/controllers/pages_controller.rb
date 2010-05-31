class PagesController < ApplicationController

  skip_before_filter :authenticate_user!, :only => 'show'

  def show
    @page = Page.find_by_title(params[:slug])
  end
end
