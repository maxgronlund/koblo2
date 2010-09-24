class Song < ActiveRecord::Base

  belongs_to :user
  has_many :tracks
  has_many :ratings
  belongs_to :category

  has_attached_file :mixdown
  has_attached_file :multitrack_zip_file

  accepts_nested_attributes_for :tracks

  scope :best, joins(:ratings).group('ratings.song_id').order('AVG(ratings.value) DESC')
  scope :newest, order('created_at DESC')

  def rating
    ratings.average(:value)
  end

  define_index do
    indexes :title
  end
  
  after_create :process_audio

  def process_audio 
    Resque.enqueue(CreateMixdown, id)
  end

  composed_of :multitrack_price,
    :class_name => "Money",
    :mapping => [%w(multitrack_price_in_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }

  composed_of :mixdown_price,
    :class_name => "Money",
    :mapping => [%w(mixdown_price_in_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }

  composed_of :ringtone_price,
    :class_name => "Money",
    :mapping => [%w(ringtone_price_in_cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }
  
end
