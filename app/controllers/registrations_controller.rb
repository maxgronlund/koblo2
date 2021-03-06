class RegistrationsController < Devise::RegistrationsController 

  def create
    build_resource

    if resource.save
      set_flash_message :notice, :signed_up
      sign_in(resource_name, resource)
    else
      clean_up_passwords(resource)
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
    else
      clean_up_passwords(resource)
    end

    render :action => :create
  end

end
