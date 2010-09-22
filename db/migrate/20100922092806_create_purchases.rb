class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.belongs_to :user
      t.boolean :completed, :default => false
      t.integer :price_in_cents
      t.string :currency
      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
