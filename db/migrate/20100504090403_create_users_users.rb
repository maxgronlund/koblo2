class CreateUsersUsers < ActiveRecord::Migration
  def self.up
    create_table :users_users, :id => false do |t|
      t.integer :fan_id
      t.integer :idol_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users_users
  end
end
