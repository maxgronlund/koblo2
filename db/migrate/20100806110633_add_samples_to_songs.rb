class AddSamplesToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :samples, :integer
  end

  def self.down
    remove_column :songs, :samples
  end
end
