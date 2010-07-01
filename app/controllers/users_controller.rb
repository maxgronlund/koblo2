class UsersController < ApplicationController

  skip_before_filter :authenticate_user!
  before_filter :sidebar_for_user, :only => :show
  before_filter :sidebar_for_frontpage, :only => :index
  layout 'frontpage_content', :only => :index

  def index
    unless params[:record_label_id].blank?
      @record_label = RecordLabel.find(params[:record_label_id])
      @users = User.where(:record_label_id => @record_label)
    else
      @users = User.all
    end
    @users = @users.paginate(:per_page => 10, :page => (params[:page] || 1))
  end

  def show
    redirect_to user_activities_path(@user)
  end

end
