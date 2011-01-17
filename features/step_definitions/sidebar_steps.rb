Then /^I should see the (.*?) sidebar widget (.*?)$/ do |model, widget|
	Then "I should see \"#{I18n.translate("#{model}.#{widget.gsub(/\s+/, '_')}_title")}\""
end

Then /^I should see the (.*?) sidebar widget$/ do |widget|
	Then %{I should see "#{I18n.translate("#{widget.gsub(/\s+/, '_')}_title")}"}
end

Then /^I should see the (.*?) widget with meta "([^"]+)"$/ do |widget, meta|
	Then %{I should see "#{I18n.translate("#{widget.gsub(/\s+/, '_')}.#{meta}")}"}
end

Then /^I should see the widget who liked$/ do
  raise I18n.translate("who_liked.title", :user_count => 0)
  Then %{I should see "#{I18n.translate("who_liked.title", :user_count => 0)}"}
end
