class Song < ActiveRecord::Base

  belongs_to :user
  has_many :tracks
  has_many :ratings
  belongs_to :category

  has_attached_file :mixdown

  accepts_nested_attributes_for :tracks

  scope :best, joins(:ratings).group('ratings.song_id').order('AVG(ratings.value) DESC')
  scope :newest, order('created_at DESC')

  def rating
    ratings.average(:value)
  end

  define_index do
    indexes title
  end
  
  after_create :process_audio

  def process_audio 
    Resque.enqueue(CreateMixdown, id)
  end
end
