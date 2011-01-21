Factory.define :user do |f|
  f.login                   { Faker::Internet.user_name + rand(5124123).to_s }
  f.name                    { Faker::Name.name }
  f.email                   { Faker::Internet.email }
  f.password                { "asdfasdf" }
  f.password_confirmation   { "asdfasdf" }
end

Factory.define :content do |f|
  f.title     Faker::Company.catch_phrase
  f.url       "http://#{Faker::Internet.domain_name}"
  f.caption   Faker::Lorem.paragraph
  f.association :user, :factory => :user
end

Factory.define :article do |f|
  f.body   Faker::Lorem.paragraph
  # TODO:: ADD VALIDATION FOR USER
  f.association :author, :factory => :user
  #f.association :content, :factory => :content
  f.content {|a| a.association :content, :user => a.author }
end

Factory.define :gallery do |f|
  f.title       Faker::Company.catch_phrase
  f.description Faker::Lorem.paragraph
  f.association :user, :factory => :user
end

Factory.define :gallery_item do |f|
  f.item_url    "http://dummyimage.com/200x200.jpg"
  f.association :gallery, :factory => :gallery
end

Factory.define :video do |f|
  f.remote_video_url  "http://www.youtube.com/watch?v=ObR3qi4Guys"
end

Factory.define :forum do |f|
  f.name        Faker::Company.catch_phrase
  f.description Faker::Lorem.paragraph
end

Factory.define :topic do |f|
  f.title       Faker::Company.catch_phrase
  f.body        Faker::Lorem.paragraph
  f.association :user, :factory => :user
  f.association :forum, :factory => :forum
end
