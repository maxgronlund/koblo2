require File.dirname(__FILE__) + '/test_helper'

class ActsAsFollowableTest < Test::Unit::TestCase

  context "instance methods" do
    setup do
      @sam = Factory(:sam)
    end

    should "be defined" do
      assert @sam.respond_to?(:followers_count)
      assert @sam.respond_to?(:followers)
      assert @sam.respond_to?(:followed_by?)
    end
  end

  context "acts_as_followable" do
    setup do
      @sam = Factory(:sam)
      @jon = Factory(:jon)
      @sam.follow(@jon)
    end

    context "followers_count" do
      should "return the number of followers" do
        assert_equal 0, @sam.followers_count
        assert_equal 1, @jon.followers_count
      end

      should "return the proper number of multiple followers" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        assert_equal 0, @sam.followers_count
        assert_equal 1, @jon.followers_count
        assert_equal 1, @bob.followers_count
      end

      should "return the number of active followers only" do
        @bob = Factory(:bob)
        @sam.follow(@bob, :active => false)

        assert_equal 0, @bob.followers_count
      end
    end

    context "inactive_followers_count" do
      setup do
        @bob = Factory(:bob)
        @sam.follow(@bob, :active => false)
      end

      should "return the number of inactive followers" do
        assert_equal 1, @bob.inactive_followers_count
      end
    end

    context "followers" do
      should "return users" do
        assert_equal [], @sam.followers
        assert_equal [@sam], @jon.followers
      end

      should "return users (multiple followers)" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        assert_equal [], @sam.followers
        assert_equal [@sam], @jon.followers
        assert_equal [@sam], @bob.followers
      end

      should "return users (multiple followers, complex)" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        @jon.follow(@bob)
        assert_equal [], @sam.followers
        assert_equal [@sam], @jon.followers
        assert_equal [@sam, @jon], @bob.followers
      end

      should "return active users only" do
        @bob = Factory(:bob)
        @sam.follow(@bob, :active => false)

        assert_equal [], @bob.followers
      end

      should "accept AR options" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        @jon.follow(@bob)

        assert_equal 1, @jon.followers(:limit => 1).count
      end
    end

    context "paged followers" do
      should "paginate" do
        @bob = Factory(:bob)
        @ben = Factory(:ben)

        @bob.follow(@jon)
        @ben.follow(@jon)

        assert_equal [@sam, @bob], @jon.paged_followers(:per_page => 2)
        assert_equal [@ben], @jon.paged_followers(:per_page => 2, :page => 2)

        assert_equal [@sam, @bob, @ben].size, @jon.paged_followers.total_entries
      end
    end

    context "inactive_followers" do
      setup do
        @bob = Factory(:bob)
        @sam.follow(@bob, :active => false)
        @jon.follow(@bob)
      end

      should "return inactive users" do
        assert_equal [@sam], @bob.inactive_followers
      end

      should "accept AR options" do
        @ben = Factory(:ben)
        @ben.follow(@bob, :active => false)

        assert_equal 1, @bob.inactive_followers(:limit => 1).count
      end
    end

    context "paged followings" do
      should "paginate" do
        @bob = Factory(:bob)
        @ben = Factory(:ben)
        @frodo = Factory(:frodo)

        @jon.follow(@bob)
        @jon.follow(@ben)
        @jon.follow(@sam)
        @jon.follow(@frodo)

        assert_equal [@bob, @ben], @jon.paged_all_following(:per_page => 2)
        assert_equal [@sam, @frodo], @jon.paged_all_following(:per_page => 2, :page => 2)

        assert_equal [@bob, @ben, @sam, @frodo].size, @jon.paged_all_following.total_entries
      end
    end

    context "followed_by" do
      should "return follower status" do
        assert_equal true, @jon.followed_by?(@sam)
        assert_equal false, @sam.followed_by?(@jon)
      end

      should "return follower status for active users only" do
        @bob = Factory(:bob)
        @sam.follow(@bob, :active => false)

        assert_equal false, @bob.followed_by?(@sam)
      end
    end

    context "destroying a followable" do
      setup do
        @jon.destroy
      end

      should_change("follow count", :by => -1) { Follow.count }
      should_change("@sam.all_following.size", :by => -1) { @sam.all_following.size }
    end

    context "blocks" do
      setup do
        @bob = Factory(:bob)
        @jon.block(@sam)
        @jon.block(@bob)
      end

      should "accept AR options" do
        assert_equal 1, @jon.blocks(:limit => 1).count
      end
    end

    context "blocking a follower" do
      context "in my following list" do
        setup do
          @jon.block(@sam)
        end

        should "remove him from followers" do
          assert_equal 0, @jon.followers_count
        end

        should "add him to the blocked followers" do
          assert_equal 1, @jon.blocked_followers_count
        end

        should "not be able to follow again" do
          @jon.follow(@sam)
          assert_equal 0, @jon.followers_count
        end

        should "not be present when listing followers" do
          assert_equal [], @jon.followers
        end

        should "be in the list of blocks" do
          assert_equal [@sam], @jon.blocks
        end
      end

      context "not in my following list" do
        setup do
          @sam.block(@jon)
        end

        should "add him to the blocked followers" do
          assert_equal 1, @sam.blocked_followers_count
        end

        should "not be able to follow again" do
          @sam.follow(@jon)
          assert_equal 0, @sam.followers_count
        end

        should "not be present when listing followers" do
          assert_equal [], @sam.followers
        end

        should "be in the list of blocks" do
          assert_equal [@jon], @sam.blocks
        end
      end
    end

    context "unblocking a blocked follow" do
      setup do
        @jon.block(@sam)
        @jon.unblock(@sam)
      end

      should "not include the unblocked user in the list of followers" do
        assert_equal [], @jon.followers
      end

      should "remove him from the blocked followers" do
        assert_equal 0, @jon.blocked_followers_count
        assert_equal [], @jon.blocks
      end
    end

    context "unblock a non-existent follow" do
      setup do
        @sam.stop_following(@jon)
        @jon.unblock(@sam)
      end

      should "not be in the list of followers" do
        assert_equal [], @jon.followers
      end

      should "not be in the blockked followers count" do
        assert_equal 0, @jon.blocked_followers_count
      end

      should "not be in the blocks list" do
        assert_equal [], @jon.blocks
      end
    end

    context "activate a inactive follow" do
      setup do
        @bob = Factory(:bob)
        @sam.follow(@bob, :active => false)
        @bob.activate(@sam)
      end

      should "remove him from the inactive followers" do
        assert_equal 0, @bob.inactive_followers_count
      end

      should "add him to the followers list" do
        assert_equal [@sam], @bob.followers
      end
    end

  end

end
