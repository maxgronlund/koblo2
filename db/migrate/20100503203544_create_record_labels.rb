class CreateRecordLabels < ActiveRecord::Migration
  def self.up
    create_table :record_labels do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :record_labels
  end
end
