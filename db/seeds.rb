# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

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
  Song.create(:title => line, :user => artists.rand)
end

# PAGES
['Why', 'Who', 'Terms', 'Help'].each { |title| Page.create(:title => title) }
