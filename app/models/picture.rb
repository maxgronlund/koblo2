class Picture < ActiveRecord::Base

  has_attached_file :picture, :styles => { :upload => '160x160#', :profile => "200x160>", :thumb => '48x48#' }

end

