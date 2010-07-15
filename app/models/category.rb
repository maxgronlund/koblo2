class Category < ActiveRecord::Base
  has_many :songs

  def self.frontpage
    joins(:songs).group('category_id').order('count(songs.id) desc').limit(5)
  end
end
