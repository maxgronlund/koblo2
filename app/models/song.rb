class Song < ActiveRecord::Base

  belongs_to :user
  has_many :tracks
  has_many :ratings

end
