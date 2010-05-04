class Activities < ActiveRecord::Migration

  def self.up
    create_table :activities do |t|
      t.column :type, :string
      t.column :user_id, :integer
      t.column :song_id, :integer
      t.column :admin_message_id, :integer
    end
  end

  def self.down
    drop_table :activities
  end

end
