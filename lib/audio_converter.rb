class AudioConverter
  @queue = :audio_conversion

  def self.perform(track_id)
    track = Track.find(track_id)
    filename_with_no_extension = track.uploaded_data_file_name.gsub(/(.*)\.(.*?)$/, '\1')
    unless track.mp3?
      mp3_file = '/tmp/' + filename_with_no_extension + ".mp3"
      `rm -f #{mp3_file}`
      stdout = `lame #{track.uploaded_data.path} #{mp3_file} 2>&1`
      unless stdout =~ /Warning: unsupported audio format/
        track.mp3 = File.new(mp3_file)
        track.save
        track.mp3.instance_write(:content_type, 'audio/mpeg')
        track.save
      end
    end
    unless track.wav?
      wav_file = '/tmp/' + filename_with_no_extension + ".wav"
      `rm -f #{wav_file}`
      stdout = `ffmpeg -i #{track.uploaded_data.path} #{wav_file} 2>&1`
      unless stdout =~ /Audio encoding failed/
        track.wav = File.new(wav_file)
        track.save
      end
    end
  end
end
