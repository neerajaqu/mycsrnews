Given /^the following comments:$/ do |comments|
  Comment.create!(comments.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) comment$/ do |pos|
  visit comments_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following comments:$/ do |expected_comments_table|
  expected_comments_table.diff!(tableish('table tr', 'td,th'))
end
