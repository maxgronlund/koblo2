class ActivitiesController < ApplicationController

  before_filter :sidebar_for_user, :only => :index
  layout 'user_content', :only => :index

  def index
    @activities = Activity.where(:user_id => @user.all_following).paginate(:per_page => 10, :page => (params[:page] || 1))
    @songs = @activities.select { |activity| activity.instance_of?(SongUploadedActivity) && activity.song }.map(&:song)
    @songs ||= []
    @songs = @songs.paginate(:per_page => 10, :page => (params[:page] || 1))
  end

end
