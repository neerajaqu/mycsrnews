Given /^the following idea_boards:$/ do |idea_boards|
  IdeaBoard.create!(idea_boards.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) idea_board$/ do |pos|
  visit idea_boards_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following idea_boards:$/ do |expected_idea_boards_table|
  expected_idea_boards_table.diff!(tableish('table tr', 'td,th'))
end
