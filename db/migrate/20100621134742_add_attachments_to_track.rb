class AddAttachmentsToTrack < ActiveRecord::Migration
  def self.up
    remove_paperclip_columns(:tracks, 'sound')
    add_paperclip_columns(:tracks, 'uploaded_data')
    add_paperclip_columns(:tracks, 'mp3')
    add_paperclip_columns(:tracks, 'wav')
  end
 
  def self.down
    add_paperclip_columns(:tracks, 'sound')
    remove_paperclip_columns(:tracks, 'wav')
    remove_paperclip_columns(:tracks, 'mp3')
    remove_paperclip_columns(:tracks, 'uploaded_data')
  end

  def self.add_paperclip_columns(table, attachment_name)
    add_column table, "#{attachment_name}_file_name", :string
    add_column table, "#{attachment_name}_content_type", :string
    add_column table, "#{attachment_name}_file_size", :integer
  end

  def self.remove_paperclip_columns(table, attachment_name)
    remove_column table, "#{attachment_name}_file_name"
    remove_column table, "#{attachment_name}_content_type"
    remove_column table, "#{attachment_name}_file_size"
  end
end
