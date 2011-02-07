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

Factory.define :comment do |f|
  f.comments    Faker::Lorem.paragraph
  f.association :user, :factory => :user
  f.commentable {|a| a.association :content, :user => a.user }
end

Factory.define :flag do |f|
  f.flag_type   Flag.flag_types.rand
  f.association :flaggable, :factory => :content
  f.association :user, :factory => :user
end

Factory.define :question do |f|
  f.question    Faker::Lorem.paragraph
  f.association :user, :factory => :user
end

Factory.define :answer do |f|
  f.answer      Faker::Lorem.paragraph
  f.association :user, :factory => :user
  f.association :question, :factory => :question
end

Factory.define :feed do |f|
  f.association :user, :factory => :user
  f.url       "http://#{Faker::Internet.domain_name}"
  f.rss       "http://#{Faker::Internet.domain_name}/feed.rss"
  f.title       Faker::Company.catch_phrase
end

Factory.define :newswire do |f|
  f.association :feed, :factory => :feed
  f.association :user, :factory => :user
  f.url         "http://#{Faker::Internet.domain_name}"
  f.title       Faker::Company.catch_phrase
  f.caption     Faker::Lorem.paragraph
end

Factory.define :event do |f|
  f.association :user, :factory => :user
  f.url         "http://#{Faker::Internet.domain_name}"
  f.name        Faker::Company.catch_phrase
end

Factory.define :idea_board do |f|
  f.name        Faker::Company.catch_phrase
  f.section     Faker::Company.catch_phrase
  f.description Faker::Lorem.paragraph
end

Factory.define :idea do |f|
  f.association :user, :factory => :user
  f.association :idea_board, :factory => :idea_board
  f.title       Faker::Company.catch_phrase
end

Factory.define :resource_section do |f|
  f.name        Faker::Company.catch_phrase
  f.section     Faker::Company.catch_phrase
  f.description Faker::Lorem.paragraph
end

Factory.define :resource do |f|
  f.association :user, :factory => :user
  f.association :resource_section, :factory => :resource_section
  f.title       Faker::Company.catch_phrase
  f.url         "http://#{Faker::Internet.domain_name}"
end

Factory.define :related_item do |f|
  f.association :user, :factory => :user
  f.association :relatable, :factory => :event
  f.title       Faker::Company.catch_phrase
  f.url         "http://#{Faker::Internet.domain_name}"
end

Factory.define :classified do |f|
  f.title       Faker::Company.catch_phrase
  f.details     Faker::Lorem.paragraph
  f.allow       "all"
  f.association :user, :factory => :user
  f.listing_type  "sale"
end
