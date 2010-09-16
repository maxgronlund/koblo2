class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :amount
      t.string :currency_code
      t.string :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
