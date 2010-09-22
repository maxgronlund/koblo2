class AddPricesToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :mixdown_price_in_cents, :integer
    add_column :songs, :multitrack_price_in_cents, :integer
    add_column :songs, :ringtone_price_in_cents, :integer
    add_column :songs, :currency, :string
  end

  def self.down
  end
end
