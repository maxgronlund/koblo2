class PasswordsController < Devise::PasswordsController
  before_filter :sidebar_for_frontpage
  layout 'frontpage_content'
end
