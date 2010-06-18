require File.dirname(__FILE__) + '/follower_lib'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Follower

      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          include FollowerLib
        end
      end

      module ClassMethods
        def acts_as_follower
          has_many :follows, :as => :follower, :dependent => :destroy
          include ActiveRecord::Acts::Follower::InstanceMethods
        end
      end

      module InstanceMethods

        # Returns true if this instance is following the object passed as an argument.
        def following?(followable)
          0 < Follow.unblocked.active.count(:all, :conditions => [
                "follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?",
                 self.id, parent_class_name(self), followable.id, parent_class_name(followable)
               ])
        end

        # Returns the number of objects this instance is following.
        def follow_count
          Follow.unblocked.active.count(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, parent_class_name(self)])
        end

        # Creates a new follow record for this instance to follow the passed object.
        # Does not allow duplicate records to be created.
        def follow(followable, options={})
          follow = get_follow(followable)
          unless follow
            if self != followable
              options = {
                :followable => followable,
                :follower => self
              }.merge(options)

              Follow.create(options)
            end
          end
        end

        # Deletes the follow record if it exists.
        def stop_following(followable)
          follow = get_follow(followable)
          if follow
            follow.destroy
          end
        end

        # Returns the follow records related to this instance by type.
        def follows_by_type(followable_type, options={})
          options = {
            :include => [:followable],
            :conditions => ["follower_id = ? AND follower_type = ? AND followable_type = ?", self.id, parent_class_name(self), followable_type]
          }.merge(options)

          Follow.unblocked.active.find(:all, options)
        end

        # Returns the follow records related to this instance with the followable included.
        def all_follows(options={})
          options = {
            :include => :followable
          }.merge(options)

          self.follows.unblocked.active.all(options)
        end

        # Returns the actual records which this instance is following.
        def all_following(options={})
          all_follows(options).collect{ |f| f.followable }
        end

        # Returns the following records paginated using will_paginate.
        def paged_all_following(options={})
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

            result = self.all_following(options)
            # inject the result array into the paginated collection:
            pager.replace(result)

            pager.total_entries = self.follow_count
          end
        end


        # Returns the actual records of a particular type which this record is following.
        def following_by_type(followable_type, options={})
          follows_by_type(followable_type, options).collect{ |f| f.followable }
        end

        # Allows magic names on following_by_type
        # e.g. following_users == following_by_type('User')
        def method_missing(m, *args)
          if m.to_s[/following_(.+)/]
            following_by_type($1.singularize.classify)
          else
            super
          end
        end

        private

        # Returns a follow record for the current instance and followable object.
        def get_follow(followable)
          Follow.unblocked.find(:first, :conditions => ["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", self.id, parent_class_name(self), followable.id, parent_class_name(followable)])
        end

      end

    end
  end
end
