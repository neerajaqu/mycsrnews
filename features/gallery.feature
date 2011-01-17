Feature: Gallery
	In order to use galleries
	As a user
	I want to be able to operate on galleries

	Scenario: List of Galleries
		Given the following galleries exist
			| title           | description                               |
			| Summer          | Pictures from the summer                  |
			| Christmas Party | Pictures from this year's christmas party |
		When I am on the galleries page
		Then I should see the galleries table
			| title           | description                               |
			| Summer          | Pictures from the summer                  |
			| Christmas Party | Pictures from this year's christmas party |
		And I should see the galleries sidebar widget whatis this
		And I should see the galleries sidebar widget top galleries
		And I should see the galleries sidebar widget newest galleries

	Scenario: View a Gallery
		Given a gallery exists with title: "Pizza"
		And 5 gallery_items exist with gallery: the gallery, item_url: "http://dummyimage.com/200x200.jpg"

		When I am on the galleries page
		And I click on that gallery
		Then I should see "Pizza" within "#itemDetails h1"
		And I should see 5 images on the page
		And I should see the widget user bio
		#TODO::
		#  And I should see the related items sidebar widget
		#  And I should see the who liked widget with meta "title"
		And I should see the galleries sidebar widget voices

	Scenario: Create a Gallery
		Given a user is logged in
		And a gallery exists
		When I visit the new gallery page
		And I should see the galleries sidebar widget newest galleries
		And I should see the galleries sidebar widget top galleries
		And I fill out the new gallery form with title "Pasta"
		Then a gallery should exist with title: "Pasta"

	Scenario: Edit a Gallery
		Given a user is logged in
		And a gallery exists with user: the user
		And a gallery_item exists with gallery: the gallery
		When I visit the edit page for that gallery
		And I update the gallery form with title "My New Title"
		Then the gallery's title should be "My New Title"

	Scenario: View Galleries with a Specific Tag
		Given a gallery exists with title: "My Delicious Pizza Gallery", tag_list: "pizza"
		And 5 gallery_items exist with gallery: the gallery, item_url: "http://dummyimage.com/200x200.jpg"
		When I visit the pizza tag galleries page
		Then the page should contain "My Delicious Pizza Gallery" within "ul.galleries li a"
		And I should see the galleries sidebar widget whatis this
		And I should see the galleries sidebar widget newest galleries
		And I should see the galleries sidebar widget top galleries
		#TODO::
		#  And I should see the galleries sidebar widget top gallery tags
	
	Scenario: Contribute to a gallery
		Given a user is logged in
		And a gallery exists with is_public: true
		When I visit the show page for that gallery
		And I click the galleries link add_new_item
		And I fill out the new gallery item form
		Then the gallery should have 1 gallery_items

	#TODO:: NEED JS ENGINE FOR THIS TO WORK
	#Scenario: #Create a #Gallery with multiple #Gallery #Items
		#Given #I am a logged in user
		#Given a gallery exists
		#When #I visit the new gallery page
		#And #I should see the galleries sidebar widget newest galleries
		#And #I should see the galleries sidebar widget top galleries
		#And #I fill out the new gallery form with title "#Pizza" and 5 gallery items
		#Then the "#Pizza" gallery should exist and have 5 gallery items
