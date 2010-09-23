require 'zip/zip'
require 'zip/zipfilesystem'

class PurchasedSongsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :sidebar_for_user
  layout 'user_content'

  def index
    @purchase_items = current_user.purchase_items
  end

  def download
    purchase_item = current_user.purchase_items.find(params[:purchased_song_id])
    song = purchase_item.song
    # From http://info.michael-simons.eu/2008/01/21/using-rubyzip-to-create-zip-files-on-the-fly/
    t = Tempfile.new(UUID.new.generate)
    # Give the path of the temp file to the zip outputstream, it won't try to open it as an archive.
    Zip::ZipOutputStream.open(t.path) do |zos|
      song.tracks.each do |track|
        # Create a new entry with some arbitrary name
        extension = { 'multitrack' => :wav, 'mixdown' => :mp3, 'ringtone' => :mp3 }[purchase_item.format]
        zos.put_next_entry(track.title + "." + extension.to_s)
        # Add the contents of the file, don't read the stuff linewise if its binary, instead use direct IO
        format = { 'multitrack' => :wav, 'mixdown' => :mp3, 'ringtone' => 'ringtone' }[purchase_item.format]
        zos.print IO.read(track.send(format).path)
      end
    end
    # End of the block  automatically closes the file.

    # Send it using the right mime type, with a download window and some nice file name.
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{song.title}-#{purchase_item.format}.zip"
    # The temp file will be deleted some time...
    t.close
  end
end
