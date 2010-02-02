Given /^the following resources:$/ do |resources|
  Resource.create!(resources.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) resource$/ do |pos|
  visit resources_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following resources:$/ do |expected_resources_table|
  expected_resources_table.diff!(tableish('table tr', 'td,th'))
end
