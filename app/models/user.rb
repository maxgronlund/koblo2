class User < ActiveRecord::Base

  belongs_to :record_label

  has_many :albums
  has_many :songs, :through => :albums

  has_many :idols
  has_many :fans

  has_attached_file :picture, :styles => { :bigger => "73x73>", :normal => '48x48>', :mini => "24x24>" }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation
end
