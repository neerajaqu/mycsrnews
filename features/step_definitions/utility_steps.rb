Given /^I visit (the .*? page(?: for that .+)?)$/ do |page|
	visit path_to(page)
end
