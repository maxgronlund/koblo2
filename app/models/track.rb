require 'audio_converter'

class Track < ActiveRecord::Base

  belongs_to :song
  belongs_to :user

  has_attached_file :uploaded_data
  has_attached_file :mp3
  has_attached_file :wav
  has_attached_file :waveform

  after_create :process_audio

  def process_audio
    Resque.enqueue(AudioConverter, id)
    Resque.enqueue(CreateWaveform, id)
  end

  def self.regenerate_waveforms
    all.each { |track| CreateWaveform.perform(track.id) }
  end

end
