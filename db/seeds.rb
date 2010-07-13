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

# PAGES
{ 1 => 'Why', 
  2 => 'Who',
  3 => 'Terms',
  4 => 'Help'
}.each do |id, title|
  page = Page.find_by_id(id)
  unless page
    page = Page.create(:id => id)
    body = File.readlines("#{Rails.root}/db/#{title.downcase}.html")
  end
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
