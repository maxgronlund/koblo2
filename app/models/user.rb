class User < ActiveRecord::Base

  acts_as_followable
  acts_as_follower

  # http://wiki.github.com/ryanb/cancan/role-based-authorization
  ROLES = %w{admin musician dj producer wannabe record_label}

  belongs_to :record_label

  has_many :songs

  has_attached_file :picture, :styles => { :bigger => "73x73>", :normal => '48x48>', :mini => "24x24>" }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :name

  def admin?
    role == 'admin'
  end

  scope :connections, lambda { |user| 
    joins(:follows).where('(follows.follower_id = ? OR follows.followable_id = ?) AND follows.follower_type = ?', user.id, user.id, User.to_s)
  }

  def connections
    User.connections(self)
  end

end
