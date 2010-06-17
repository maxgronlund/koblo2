class AddMissingColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :record_label_id, :integer
    add_column :users, :website, :string
    add_column :users, :description, :text
  end

  def self.down
    remove_column :users, :description
    remove_column :users, :website
    remove_column :users, :record_label_id
  end
end
