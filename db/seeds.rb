# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

RECORD_LABELS =<<EOT
Copenhagen Records
Sony Music Entertainment
EMI Group
Warner Music Group
Universal Music Group
Sub Pop
Virgin
Mute Records
Motown Records
Other
EOT

RECORD_LABELS.split("\n").each do |name|
  RecordLabel.find_or_create_by_name(name)
end

# USERS
CPH_RECORDS_ARTISTS =<<EOT
Agnes
Alphabeat
Burhan G
Carpark North
Celina Ree
Eivør Pálsdóttir
Hej Matematik
Jinks
Joey Moe
Johnny Deluxe
Mads Langer
Nephew
Niarn
Rock Hard Power Spray
Spleen United
Thomas Dybdahl
EOT

artists = []
CPH_RECORDS_ARTISTS.split("\n").each do |name|
  artists << User.create(:name => name, :email => "info@#{name.parameterize}.com", :password => 'ohdoot5Chao0')
end

# SONGS
File.open('db/fixtures/u2_songs.txt').each_line do |line|
  line.gsub!(/^"/, '')
  line.gsub!(/"$/, '')
  unless Song.find_by_title(line)
    song = Song.create(:title => line, :user => artists.sample, :duration => (120 + rand(4*60)))
    (1 + rand(5)).times { song.ratings.create(:value => (1 + rand(5))) }
  end
end

# PAGES
{ 1 => 'Why', 
  2 => 'Who',
  3 => 'Terms',
  4 => 'Help'
}.each do |id, title|
  page = Page.find_or_create_by_id(id)
  body = File.readlines("#{Rails.root}/db/#{title.downcase}.html")
  page.update_attributes(:title => title, :body => body)
end

CATEGORIES =<<EOT
alternative
blues
children's music
Christian & gospel
classical
comedy
country
dance
electronic
hip-hop/rap
jazz
Latino
pop
R&B/soul
reggae
rock
singer–songwriter
soundtrack
vocal
world
EOT

CATEGORIES.split("\n").each do |name|
  Category.find_or_create_by_name(name)
end
