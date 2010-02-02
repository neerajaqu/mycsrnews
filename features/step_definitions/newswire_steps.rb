Given /^the following newswires:$/ do |newswires|
  Newswire.create!(newswires.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) newswire$/ do |pos|
  visit newswires_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following newswires:$/ do |expected_newswires_table|
  expected_newswires_table.diff!(tableish('table tr', 'td,th'))
end
