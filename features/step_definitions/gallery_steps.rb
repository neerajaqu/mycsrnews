Then /^I should see an empty list of galleries$/ do
  page.should have_selector('ul.galleries')
  page.should have_no_selector('ul.galleries li')
end

When /^I click on the (.*?) gallery$/ do |title|
	When "I follow \"#{@gallery.title}\" within \"ul.galleries li[@data-id='#{@gallery.cache_key}']\""
end

Then /^I should see be on the show pizza gallery page$/ do
	Then "I should see \"#{@gallery.title}\" within \"#itemDetails h1\""
end

When /^I click on that gallery$/ do
	gallery = model('gallery')
	When "I follow \"#{gallery.title}\" within \"ul.galleries li[@data-id='#{gallery.cache_key}']\""
end

When /^I fill out the new gallery item form$/ do
  fill_in "Item url", :with => "http://dummyimage.com/200x200.jpg"
	click_button "gallery_item_submit"
end

When /^I update the gallery form with title "([^"]+)"$/ do |title|
  fill_in "gallery_title", :with => title
	click_button "gallery_submit"
end

Then /^I should have a new gallery$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^there is a (.*?) gallery(?: with ([0-9]+) images)?$/ do |title, images_count|
	@gallery = Factory.create(:gallery, :title => title)
end

Then /^I should see the galleries table$/ do |galleries_table|
	galleries_table.hashes.each do |gallery|
		all('ul.galleries li .itemBlock h2 a').select {|e| e.text == gallery['title']}.should have(1).things
		all('ul.galleries li .itemBlock p').select {|e| e.text == gallery['description']}.should have(1).things
	end
end

When /^I fill out the new gallery form with title "([^\"]*)"(?: and ([0-9]+) gallery items)?$/ do |title, count|
	fill_in "Title", :with => title
	fill_in "Description", :with => Faker::Lorem.paragraph
	if count.nil?
		fill_in "Item url", :with => "http://dummyimage.com/200x200.jpg"
	else
		(count.to_i - 1).times { puts "Clicking link"; click_link "add_gallery_item" }
		puts "Found #{all('fieldset#gallery-items-fieldset li input').count} inputs"
		all('fieldset#gallery-items-fieldset li input').each do |item_url_input|
		  puts "Adding item"
			i = [2..6].to_a.rand
			fill_in item_url_input[:id], :with => "http://dummyimage.com/#{i}00x#{i}00.jpg"
		end
	end
	click_button "gallery_submit"
end

Then /^the "([^"]*)" gallery should exist and have (\d+) gallery items$/ do |title, count|
	gallery = Gallery.find_by_title(title)
	gallery.should_not be_nil
	gallery.gallery_items.count.should == count.to_i
end

Then /^I should see (\d+) images on the page$/ do |num_images|
  all(".gallery img").count.should == num_images.to_i
end
