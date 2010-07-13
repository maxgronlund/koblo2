require 'RMagick'
include Magick

class CreateWaveForm

  WIDTH = 450
  HEIGHT = 40

  def self.create(track_id)
    gradient = GradientFill.new(0, 0, WIDTH, 0, "#04333d", "#01848e")
    image = Image.new(WIDTH, HEIGHT, gradient)
    image.write('gradient.jpg')
  end
  
end

#this class was inspired by rjp's awesome http://github.com/rjp/cdcover
require 'rubygems'
require 'RMagick'
require 'narray'
#require 'unprof'

#fill the buckets
def fill_buckets width,file
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

#open file with sox and return a byte array with sweet waveform information in it
def sox_get_bytes file
  x=nil
  # read a 16 bit linear raw PCM file
  sox_command = [ 'sox', file, '-t', 'raw', '-r', '400', '-c', '1', '-s', '-L', '-' ]
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

#build the waveform graph
def build_graph buckets,size,height
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

# graph parameters
width = size = 450
height = 40
#width = (0.9*size+0.5).to_i
file = 'dtap_mix.wav'
output = 'dtap_mix.png'

buckets = fill_buckets width,file
gc = build_graph buckets,size,height

gradient = GradientFill.new(0, 0, width, 0, "#04333d", "#01848e")
canvas = Magick::Image.new(width, height, gradient)
gc.draw(canvas)
canvas.write(output)

