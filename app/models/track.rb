class Track < ActiveRecord::Base

  belongs_to :song

  has_attached_file :sound

end
