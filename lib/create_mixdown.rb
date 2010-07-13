class CreateMixdown
  @queue = :audio_conversion
  
  def self.perform(song_id)
    song = Song.find(song_id)
    if !song.mixdown?
      track_options = song.tracks.map { |track| track.uploaded_data_file_name.ends_with?('mp3') ? "-t mp3 #{track.uploaded_data.path}" : track.uploaded_data.path }.join(' ')
      tempfile = TempfileWithExtension.new('mixdown.mp3')
      `sox -m #{track_options} -t wav -s - | lame - #{tempfile.path}`
      song.mixdown = tempfile
      song.save
    end
  end
end
