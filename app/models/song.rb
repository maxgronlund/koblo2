class Song < ActiveRecord::Base

  belongs_to :user
  has_many :tracks
  has_many :ratings

  scope :best, joins(:ratings).order('ratings.value DESC')
  scope :newest, order('created_at DESC')

  def rating
    ratings.average(:value)
  end
end
