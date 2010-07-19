class CreateUserTypes < ActiveRecord::Migration
  def self.up
    create_table :user_types do |t|
      t.string :name
      t.timestamps
    end

    add_column :users, :user_type_id, :integer
  end

  def self.down
    remove_column :users, :user_type_id

    drop_table :user_types
  end
end
