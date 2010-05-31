require 'spec_helper'

describe Song do

  describe 'best named_scope' do

    before :each do
      @unrated_song = Song.make
      @low_rated_song = Song.make
      @low_rated_song.ratings.create(:value => 1)
      @medium_rated_song = Song.make
      @medium_rated_song.ratings.create(:value => 3)
      @high_rated_song = Song.make
      @high_rated_song.ratings.create(:value => 5)
    end

    it 'should return the songs with the highest ratings' do
      Song.best.limit(2).should include(@high_rated_song)
      Song.best.limit(2).should include(@medium_rated_song)
    end
  end

  describe 'newest named_scope' do
    it 'should return the newest songs' do
      old_song = Song.make(:created_at => 1.week.ago)
      new_song = Song.make(:created_at => 2.days.ago)
      Song.newest.limit(1).should include(new_song)
    end
  end
end
