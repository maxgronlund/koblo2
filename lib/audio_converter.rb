class AudioConverter
  @queue = :audio_conversion

  def self.perform(track_id)
    track = Track.find(track_id)
    path_with_no_extension = track.uploaded_data.path.gsub(/(.*)\.(.*?)$/, '\1')
    unless track.mp3?
      mp3_file = path_with_no_extension + ".mp3"
      exit_code = system("ffmpeg -ab 128k -i #{track.uploaded_data.path} #{mp3_file}")
      if exit_code == 0
        track.mp3 = File.new(mp3_file)
        track.save
      end
    end
  end
end
