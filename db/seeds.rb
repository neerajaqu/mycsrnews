# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
IdeaBoard.create({:name => 'General', :section =>'general',:description=>'General ideas.'})
ResourceSection.create({:name => 'General', :section =>'general',:description=>'General links.'})

# Create Metadata settings
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'default', :data => { :name => 'default_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'stories', :data => { :name => 'stories_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'articles', :data => { :name => 'articles_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'newswires', :data => { :name => 'newswires_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'ideas', :data => { :name => 'ideas_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'idea_boards', :data => { :name => 'idea_boards_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'resources', :data => { :name => 'resources_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ad-slot-name', :key_name => 'events', :data => { :name => 'events_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'content', :key_type => 'page', :key_name => 'about', :data => { :content => "<h1>About Us</h1><p>This is your about content.</p>"} })
Metadata.create({:meta_type => 'content', :key_type => 'page', :key_name => 'faq', :data => { :content => "<h1>Frequently Asked Questions</h1><p>Beginning of questions goes here.</p>"} })
Metadata.create({:meta_type => 'content', :key_type => 'page', :key_name => 'terms', :data => { :content => "<h1>Terms of Use</h1><p>Terms of service for this application go here.</p>"} })
