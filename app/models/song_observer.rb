class SongObserver < ActiveRecord::Observer
  def after_create(song)
    SongUploadedActivity.create(:song => song, :user => song.user)
  end
end
