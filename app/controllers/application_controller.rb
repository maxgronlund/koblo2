class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  before_filter :authenticate_user!

  def require_admin
    unless (current_user && current_user.admin?)
      redirect_to root_path
    end
  end

end
