class RecordLabel < ActiveRecord::Base
  has_many :artists, :class => User
end
