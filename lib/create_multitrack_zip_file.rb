require 'zip/zip'
require 'zip/zipfilesystem'

class CreateMultitrackZipFile < BaseTask
  @queue = :file_compression

  def self.perform_delegate(song_id)
    song = Song.find(song_id)
    path = "/tmp/#{UUID.new.generate}/#{song.title}.zip"
    FileUtils.mkdir_p File.dirname(path)
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |zipfile|
      song.tracks.each do |track|
        zipfile.add(track.title + ".wav", track.wav.path)
      end
    end
    song.multitrack_zip_file = File.new(path)
    song.save
  end
end
