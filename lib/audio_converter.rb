class AudioConverter
  @queue = :audio_conversion

  def self.perform(track_id)
    track = Track.find(track_id)

    unless track.mp3?
      mp3_file = TempfileWithExtension.new('track.mp3').path
      system('lame', track.uploaded_data.path, mp3_file)
      track.mp3 = File.new(mp3_file)
      track.save
    end

    unless track.wav?
      wav_file = TempfileWithExtension.new('track.wav').path
      system('ffmpeg', '-y', '-i', track.uploaded_data.path, wav_file)
      track.wav = File.new(wav_file)
      track.save
    end
  end
end
