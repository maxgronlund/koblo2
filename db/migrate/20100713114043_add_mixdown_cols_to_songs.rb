class AddMixdownColsToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :mixdown_file_name, :string
    add_column :songs, :mixdown_content_type, :string
    add_column :songs, :mixdown_content_file_size, :integer
  end

  def self.down
    remove_column :songs, :mixdown_file_name
    remove_column :songs, :mixdown_content_type
    remove_column :songs, :mixdown_content_file_size
  end
end
