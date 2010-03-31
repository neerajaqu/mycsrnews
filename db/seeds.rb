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
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'banner', :key_name => 'default', :data => { :name => 'slot_banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'leaderboard', :key_name => 'default', :data => { :name => 'slot_leaderboard', :width => "728px", :height => "90px", :background => "default/ads_728_90.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'small_square', :key_name => 'default', :data => { :name => 'slot_small_square', :width => "200px", :height => "200px", :background => "default/ads_200_200.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'skyscraper', :key_name => 'default', :data => { :name => 'slot_skyscraper', :width => "160px", :height => "600px", :background => "default/ads_160_600.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'square', :key_name => 'default', :data => { :name => 'slot_square', :width => "250px", :height => "250px", :background => "default/ads_250_250.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'medium_rectangle', :key_name => 'default', :data => { :name => 'slot_medium_rectangle', :width => "300px", :height => "250px", :background => "default/ads_300_250.gif" } })
Metadata.create({:meta_type => 'config', :key_type => 'ads', :key_sub_type => 'large_rectangle', :key_name => 'default', :data => { :name => 'slot_large_rectangle', :width => "336px", :height => "280px", :background => "default/ads_336_280.gif" } })
