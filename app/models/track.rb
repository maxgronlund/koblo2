class Track < ActiveRecord::Base

  belongs_to :song
  belongs_to :user

  has_attached_file :uploaded_data
  has_attached_file :mp3
  has_attached_file :wav

end
