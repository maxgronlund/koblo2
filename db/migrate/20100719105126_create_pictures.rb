class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string   :picture_file_name
      t.string   :picture_content_type
      t.integer  :picture_file_size
      t.datetime :picture_updated_at
      t.timestamps
    end

    add_column :users, :picture_id, :integer

    remove_column :users, :picture_file_name
    remove_column :users, :picture_content_type
    remove_column :users, :picture_file_size
    remove_column :users, :picture_updated_at
  end

  def self.down
    remove_column :users, :picture_id

    add_column :users, :picture_file_name, :string
    add_column :users, :picture_content_type, :string
    add_column :users, :picture_file_size, :integer
    add_column :users, :picture_updated_at, :datetime

    drop_table :pictures
  end
end
