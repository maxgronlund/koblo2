class PasswordsController < Devise::PasswordsController
  before_filter :sidebar_for_frontpage
  layout 'frontpage_content'

  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to root_path
    else
      render_with_scope :new
    end
  end
  
end
