require 'spec_helper'

describe Follow do

  describe '.for_user' do
    before :each do
      @follower = User.make
      @followable = User.make
      @follow = @follower.follow(@followable)
    end

    it 'should return the followers' do
      Follow.for_user(@follower).should == [@follow] 
    end

    it 'should return the followables' do
      Follow.for_user(@followable).should == [@follow] 
    end

    it 'should return only one instance if it is a bidirectional connection' do
      @followable.follow(@follower)
      Follow.for_user(@follower).size == 1
      Follow.for_user(@followable).size == 1
    end
  end
end
