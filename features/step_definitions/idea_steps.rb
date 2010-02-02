Given /^the following ideas:$/ do |ideas|
  Idea.create!(ideas.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) idea$/ do |pos|
  visit ideas_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following ideas:$/ do |expected_ideas_table|
  expected_ideas_table.diff!(tableish('table tr', 'td,th'))
end
