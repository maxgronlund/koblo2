class AddWaveformToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :waveform_file_name, :string
    add_column :tracks, :waveform_content_type, :string
    add_column :tracks, :waveform_content_file_size, :integer
  end

  def self.down
    remove_column :tracks, :waveform_file_name
    remove_column :tracks, :waveform_content_type
    remove_column :tracks, :waveform_content_file_size
  end
end
