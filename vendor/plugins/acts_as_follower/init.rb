require File.dirname(__FILE__) + '/lib/acts_as_follower'
require File.dirname(__FILE__) + '/lib/acts_as_followable'

require "rubygems"
require "will_paginate"

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Follower)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Followable)
