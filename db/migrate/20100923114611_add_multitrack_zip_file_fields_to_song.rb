class AddMultitrackZipFileFieldsToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :multitrack_zip_file_file_name, :string
    add_column :songs, :multitrack_zip_file_content_type, :string
    add_column :songs, :multitrack_zip_file_content_file_size, :integer
  end

  def self.down
    remove_column :songs, :multitrack_zip_file_file_name
    remove_column :songs, :multitrack_zip_file_content_type
    remove_column :songs, :multitrack_zip_file_content_file_size
  end
end
