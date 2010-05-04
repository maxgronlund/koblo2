class CreateAdminMessages < ActiveRecord::Migration

  def self.up
    create_table :admin_messages do |t|
      t.column :title, :string
      t.column :body, :text
    end
  end

  def self.down
    drop_table :admin_messages
  end

end
