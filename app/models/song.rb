class Song < ActiveRecord::Base

  belongs_to :album
  has_many :tracks

end
