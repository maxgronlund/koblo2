class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  before_filter :authenticate_user!
  before_filter :make_controller_and_action_name_available_to_the_views

  def require_admin
    unless (current_user && current_user.admin?)
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      user_path(resource)
    else
      super
    end
  end

  def make_controller_and_action_name_available_to_the_views
    @controller_name = controller_name
    @action_name = action_name
  end

end
