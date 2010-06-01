class Song < ActiveRecord::Base

  belongs_to :user
  has_many :tracks
  has_many :ratings

  scope :best, joins(:ratings).group('ratings.song_id').order('AVG(ratings.value) DESC')
  scope :newest, order('created_at DESC')

  def rating
    ratings.average(:value)
  end

  scoped_search :on => [:title]
end
