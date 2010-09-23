class User < ActiveRecord::Base

  acts_as_followable
  acts_as_follower

  # http://wiki.github.com/ryanb/cancan/role-based-authorization
  ROLES = %w{admin}

  belongs_to :record_label
  belongs_to :user_type

  has_many :songs
  has_many :tracks
  belongs_to :picture
  has_many :purchases
  has_many :purchase_items, :through => :purchases
  has_many :purchased_songs, :through => :purchase_items, :source => :song
  has_many :adyen_notifications

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :name, :picture_id, :user_type_id, :record_label_id, :description, :website
  
  define_index do
    indexes :name
    indexes :description
  end

  before_save :add_picture

  def picture?
    picture && picture.picture?
  end

  def admin?
    role == 'admin'
  end

  def add_picture 
    self.picture = Picture.create if !picture
  end

  scope :connections, lambda { |user| 
    joins(:follows).where('(follows.follower_id = ? OR follows.followable_id = ?) AND follows.follower_type = ?', user.id, user.id, User.to_s)
  }

  def connections
    User.connections(self)
  end

end
