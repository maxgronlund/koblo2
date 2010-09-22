class CreatePurchaseItems < ActiveRecord::Migration
  def self.up
    create_table :purchase_items do |t|
      t.belongs_to :purchase
      t.belongs_to :song
      t.string :format
      t.integer :price_in_cents
      t.string :currency
      t.timestamps
    end
  end

  def self.down
    drop_table :purchase_items
  end
end
