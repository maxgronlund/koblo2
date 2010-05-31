class SongObserver < ActiveRecord::Observer
  def after_create(song)
    SongUploadedActivity.create(:song => song)
  end
end
