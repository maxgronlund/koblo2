require 'machinist/active_record'
require 'sham'
require 'ffaker'

Sham.name { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.password { (0..8).map{ ('a'..'z').to_a.sample }.join }
Sham.description { Faker::Lorem.paragraphs(1).join }
Sham.website { Faker::Internet.domain_name }

Song.blueprint do
end

User.blueprint do
  name
  email
  password
  website
  description
end

Follow.blueprint do
end
