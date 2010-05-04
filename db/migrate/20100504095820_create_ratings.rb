class CreateRatings < ActiveRecord::Migration

  def self.up
    create_table :ratings do |t|
      t.column :song_id, :integer
      t.column :value, :integer
    end
  end

  def self.down
    drop_table :ratings
  end

end
