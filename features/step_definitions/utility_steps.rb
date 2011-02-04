Given /^I visit (the .*? page(?: for that .+)?)$/ do |page|
	visit path_to(page)
end

Then /^I should (not )?see the owner edit link for that (.+)$/ do |switch, model_klass|
	klass = model(model_klass)
	user = model('user')
	#Then %{I should see "#{edit_polymorphic_path(klass)}" within "span.user-#{user.id}"}
	links = all("span.user-#{user.id} a").select {|e| e[:href] == edit_polymorphic_path(klass, :format => 'html') }
	expected = switch.nil? ? 1 : :no
	links.should have(expected).things
end

