require 'audio_converter'

class Track < ActiveRecord::Base

  belongs_to :song
  belongs_to :user

  has_attached_file :uploaded_data
  has_attached_file :mp3
  has_attached_file :wav
  has_attached_file :waveform

  after_create :convert_audio

  def convert_audio
    Resque.enqueue(AudioConverter, id)
  end

end
