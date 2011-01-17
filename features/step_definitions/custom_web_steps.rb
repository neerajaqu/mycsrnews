Then /^the page should contain "([^"]*)" within "([^"]*)"$/ do |text, selector|
  all(selector).select {|e| e.text == text}.should have_at_least(1).things
end

And /^I click the (.*?) link(?: (.+))$/ do |name, extra|
  str = I18n.translate(extra ? "#{name}.#{extra}" : name)
  When %{I follow "#{str}"}
end
