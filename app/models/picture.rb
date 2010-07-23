class Picture < ActiveRecord::Base

  has_attached_file :picture, :styles => { :profile => '200x200#', :profile_bw => "200x200#", :thumb => '48x48#', :thumb_bw => '48x48#' },
                              :default_url => "/images/dummy_:style.png",
                              :convert_options => { :profile_bw => "-colorspace Gray", :thumb_bw => "-colorspace Gray" }

  delegate :url, :to => :picture

end

