# Inspired by http://github.com/pangdudu/rude/blob/master/lib/waveform_narray_testing.rb
require 'narray'
require 'RMagick'
include Magick

class CreateWaveform
  @queue = :audio_conversion

  WIDTH = 450
  HEIGHT = 40

  def self.perform(track_id)
    track = Track.find(track_id)
    file = track.uploaded_data.path
    buckets = fill_buckets WIDTH,file
    gc = build_graph buckets,WIDTH,HEIGHT

    canvas = Magick::Image.new(WIDTH, HEIGHT) do
      self.background_color = 'transparent'
    end
    gc.draw(canvas)

    # Write waveform to temp file
    output = TempfileWithExtension.new('waveform.png')
    canvas.write(output.path)

    # And attach it to the track
    track.waveform = output
    track.save
  end

  # fill the buckets
  def self.fill_buckets width,file
    buckets = NArray.int(width,2)
    #let sox fetch the byte array
    bytes = sox_get_bytes file
    bucket_size = (((bytes.size-1).to_f / width)+0.5).to_i + 1
    (0..bytes.total-1).each do |i|
        value = bytes[i]
        index = i/bucket_size
        #minimum
        buckets[index,0] = value if value < buckets[index,0]
        #maximum
        buckets[index,1] = value if value > buckets[index,1]
        #total value
        #buckets[index,2] += value
        #count
        #buckets[index,3] += 1
        #negative total
        #buckets[index,4] += value if value < 0
        #positive total
        #buckets[index,5] += value if value > 0
    end
    return buckets
  end

  # open file with sox and return a byte array with sweet waveform information in it
  def self.sox_get_bytes file
    x=nil
    # read a 16 bit linear raw PCM file
    sox_command = [ 'sox', '-t', 'mp3', file, '-t', 'raw', '-r', '400', '-c', '1', '-s', '-L', '-' ]
    # we have to fork/exec to get a clean commandline
    IO.popen('-') { |p|
      if p.nil? then
        $stderr.close
        # raw 16 bit linear PCM one channel
        exec *sox_command
      end
      x = p.read
    }
    if x.size == 0 then
      puts "sox returned no data, command was\n> #{sox_command.join(' ')}"
      exit 1
    end
    return NArray.to_na(x.unpack("s*"))
  end

  # build the waveform graph
  def self.build_graph buckets,size,height
    gc = Magick::Draw.new  
    offset = 0.0
    scale = 32768/height
    midpoint = height/2

    (0..(buckets.size/2)-1).each do |i|
      low = buckets[i,0]
      high = buckets[i,1]
      gc.stroke('#01bec2')
      gc.stroke_width(1)
      gc.line(i+offset, midpoint+low/scale, i+offset, midpoint+high/scale)
    end
    return gc
  end
  
end
