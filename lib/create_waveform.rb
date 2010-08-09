# Inspired by http://github.com/pangdudu/rude/blob/master/lib/waveform_narray_testing.rb
require 'narray'
require 'RMagick'
include Magick

class Array
  def mean 
    sum / size.to_f
  end
end


class CreateWaveform
  @queue = :audio_conversion

  WIDTH = 490
  HEIGHT = 36 

  def self.perform(track_id)
    track = Track.find(track_id)
    file = track.uploaded_data.path

    # Read the raw data
    bytes = sox_get_bytes(file)

    # Use only absolute values
    bytes.map!(&:abs)

    # Split in left and right channel
    b = false
    left_channel, right_channel = bytes.partition { b = !b }

    # Create the graph
    gc = Magick::Draw.new  
    gc.stroke('#01bec2')
    gc.stroke_width(1)
    midpoint = HEIGHT/2
    size = left_channel.size
    sample_point = (size / (WIDTH * 4.0)).to_i
    puts sample_point

    prev_x = 0.0
    prev_y = midpoint
    j = 0
    max = 0
    left_channel.each_with_index do |sample, i|
      if i % sample_point == 0
        max = sample > max ? sample : max
        j += 1
        if j % 4 == 0
          x = WIDTH.to_f*i/size
          y = midpoint + HEIGHT*(max/32768.0)/2.0
          gc.line(prev_x, prev_y, x, y)
          max = 0
          prev_x = x
          prev_y = y
        end
      end
    end

    prev_x = 0.0
    prev_y = midpoint
    j = 0
    max = 0
    right_channel.each_with_index do |sample, i|
      if i % sample_point == 0
        max = sample > max ? sample : max
        j += 1
        if j % 4 == 0
          x = WIDTH.to_f*i/size
          y = midpoint - HEIGHT*(max/32768.0)/2.0
          gc.line(prev_x, prev_y, x, y)
          max = 0
          prev_x = x
          prev_y = y
        end
      end
    end

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

  # open file with sox and return a byte array with sweet waveform information in it
  def self.sox_get_bytes file
    x=nil
    # read a 16 bit linear raw PCM file
    if file.ends_with?('mp3')
      sox_command = [ 'sox', '-t', 'mp3', file]
    else
      sox_command = [ 'sox', file] 
    end
    sox_command += ['-t', 'raw', '-r', '500', '-s', '-L', '-' ]

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
    return x.unpack("s*")
  end
  
end
