class CreateMixdown
  @queue = :audio_conversion
  
  def self.perform(song_id)
    song = Song.find(song_id)
    if !song.mixdown?
      track_options = song.tracks.map { |track| track.uploaded_data_file_name.ends_with?('mp3') ? "-t mp3 #{track.uploaded_data.path}" : track.uploaded_data.path }.join(' ')
      tempfile = TempfileWithExtension.new('mixdown.mp3')
      `sox #{"-m" if song.tracks.size > 1} #{track_options} -t wav -s - | lame - #{tempfile.path}`
      song.mixdown = tempfile

      song_info = `sox -t mp3 #{tempfile.path} -n stat 2>&1`
      song_info =~ /Length.*?(\d+\.\d+)/
      song.duration = $1.to_f.round

      song_info = `sox -t mp3 #{tempfile.path} -n stat 2>&1`
      song_info =~ /Samples read.*?(\d+\.\d+)/
      song.samples = $1.to_i
      song.save
    end
  end
end
