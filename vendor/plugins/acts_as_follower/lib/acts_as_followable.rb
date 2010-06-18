require File.dirname(__FILE__) + '/follower_lib'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Followable

      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          include FollowerLib
        end
      end

      module ClassMethods
        def acts_as_followable
          has_many :followings, :as => :followable, :dependent => :destroy, :class_name => 'Follow'
          include ActiveRecord::Acts::Followable::InstanceMethods
        end
      end


      module InstanceMethods

        # Returns the number of followers a record has.
        def followers_count
          self.followings.unblocked.active.count
        end

        def blocked_followers_count
          self.followings.blocked.count
        end

        def inactive_followers_count
          self.followings.inactive.count
        end

        # Returns the following records.
        def followers(options={})
          options = {
            :include => [:follower]
          }.merge(options)
          self.followings.unblocked.active.all(options).collect{|f| f.follower}
        end

        # Returns the following records paginated using will_paginate.
        def paged_followers(options={})
          options = {
            :page => 1,
            :per_page => 20
          }.merge(options)

          options[:page] = 1 if options[:page].nil?

          followers = WillPaginate::Collection.create(options.delete(:page), options.delete(:per_page)) do |pager|
            options = {
              :limit => pager.per_page,
              :offset => pager.offset
            }.merge(options)

            result = self.followers(options)
            # inject the result array into the paginated collection:
            pager.replace(result)

            pager.total_entries = self.followers_count
          end
        end

        def inactive_followers(options={})
          options = {
            :include => [:follower]
          }.merge(options)
          self.followings.inactive.all(options).collect{|f| f.follower}
        end

        def blocks(options={})
          options = {
            :include => [:follower]
          }.merge(options)
          self.followings.blocked.all(options).collect{|f| f.follower}
        end

        # Returns true if the current instance is followed by the passed record
        # Returns false if the current instance is blocked by the passed record or no follow is found
        def followed_by?(follower)
          f = get_follow_for(follower)
          (f && !f.blocked? && f.active?) ? true : false
        end

        def block(follower)
          get_follow_for(follower) ? block_existing_follow(follower) : block_future_follow(follower)
        end

        def unblock(follower)
          get_follow_for(follower).try(:delete)
        end

        def activate(follower)
          get_follow_for(follower).try(:activate!)
        end

        private

        def get_follow_for(follower)
          Follow.find(:first, :conditions => ["followable_id = ? AND followable_type = ? AND follower_id = ? AND follower_type = ?", self.id, parent_class_name(self), follower.id, parent_class_name(follower)])
        end

        def block_future_follow(follower)
          follows.create(:followable => self, :follower => follower, :blocked => true)
        end

        def block_existing_follow(follower)
          get_follow_for(follower).block!
        end

      end

    end
  end
end
