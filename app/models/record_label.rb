class RecordLabel < ActiveRecord::Base
  has_many :artists, :class_name => 'User'
end
