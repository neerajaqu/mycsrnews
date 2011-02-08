@wip
Feature: Classifieds
	In order to create, buy, loan and borrow classifieds
	As a user
	I want to be able to interact with classifieds

	@wip
	Scenario: List of Galleries without a user
# TODO:: SWITCH TO TABLE WITH FREE/PUBLIC/NONPUBLIC ITEMS
		Given a classified exists with title: "My Cool Classified"
		When I am on the classifieds page
		# TODO:: Then I should see the public and free classifieds
		Then I should see "My Cool Classified"
		#But I should not see non public classifieds
		#And I should not see classifieds shared only with friends
		And I should see the classifieds sidebar widget top classifieds
		And I should see the classifieds sidebar widget newest classifieds
		And I should see the classifieds sidebar widget free classifieds
		And I should not see the classifieds sidebar widget shared classifieds
		And I should see the classifieds sidebar widget categories list

	Scenario: List of Galleries as a logged in user
		Given a user is logged in
		When I am on the classifieds page
		Then I should see the public and free classifieds
		And I should see all shareable items and friends items
		And I should see the classifieds sidebar widget top classifieds
		And I should see the classifieds sidebar widget post classifieds
		And I should see the classifieds sidebar widget newest classifieds
		And I should see the classifieds sidebar widget shared classifieds
		And I should see the classifieds sidebar widget free classifieds
		And I should see the classifieds sidebar widget categories list

	@wip
	Scenario: View a classified as a logged in user
		Given a user is logged in
		And a classified exists with aasm_state: "available"
		When I visit the show page for that classified
		Then I should see the contact link for the classified owner

	@wip
	Scenario: View a classified as a non logged in user
		Given a classified exists with aasm_state: "available"
		When I visit the show page for that classified
		Then I should not see the owner edit link for that classified
		Then I should not see the contact link for the classified owner

	Scenario: View a classified as a non owner
		Given a user is logged in
		Given a classified exists
		When I visit the show page for that classified
		Then I should not see the owner edit link for that classified
		Then I should not see the contact link for the classified owner

	Scenario: View a classified as owner
		Given a user is logged in
		And a classified exists with user: the user
		When I visit the show page for that classified
		Then I should see the owner edit link for that classified
		And I should be able to return the item
		And I should be able to renew the item
	
	Scenario: Create a new classified from scratch
		Given a user is logged in
		When I visit the new classified page
		Then I should see the new classified form
		When I fill out the new classified form with title: "Coffee for Sale"
		Then a classified should exist with title: "Coffee for Sale"
		And I should be on the classified page

	Scenario: Create a new classified from amazon api
		Given a user is logged in
		When I visit the new classified page
		Then I should see the new classified form
		When I use the amazon API to create a classified for "Let Over Lambda"
		Then a classified should exist with title: "Let Over Lambda"
		And the classified should have the appropriate item info set
	
	Scenario: Edit a Classified as Owner
		Given a user is logged in
		And a classified exists with user: the user
		When I visit the edit page for that classified
		Then I should be able to set the borrower
		And I should be able to set the state

	Scenario: Edit a Classified as Owner and renew classified
		Given a user is logged in
		And a classified exists with user: the user, aasm_state: "expired"
		When I visit the edit page for that classified
		And I renew the classified
		Then the classified's aasm_state should be "available"
	
	Scenario: View My Listings
		Given a user is logged in
		And a classified exists with user: the user, title: "My Stuff For Sale"
		When I visit the my listings classified page
		Then I should see "My Stuff For Sale"
		And I should see items I've posted
		And I should see items that are loaned out

	Scenario: View Items I'm borrowing
		Given a user is logged in
		Then TODO:: I should see items I'm borrowing

	Scenario: View Items I've loaned out
		Given a user is logged in
		And a classified exists with user: the user, title: "My Stuff For Sale", aasm_state: "loaned_out"
		When I visit the my loaned items page
		Then I should see "My Stuff For Sale"
		# And I should see items I've borrowed ??????
	
	Scenario: View Recently Viewed Items
		Given a user is logged in
		And a classified exists
		And I visit the show page for that classified
		When I visit the recently viewed classifieds page
		Then I should see that classified
