Given /^the following homes:$/ do |homes|
  Home.create!(homes.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) home$/ do |pos|
  visit homes_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following homes:$/ do |expected_homes_table|
  expected_homes_table.diff!(tableish('table tr', 'td,th'))
end
