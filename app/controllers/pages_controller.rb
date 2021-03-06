class PagesController < ApplicationController

  before_filter :require_admin, :except => :show 

  def show
    @page   = Page.find_by_short_title(params[:id])
    @page ||= Page.find_by_id(params[:id])
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    redirect_to page_path(@page)
  end
end
