Then /^the (.+?) should have (?:a )?([^:]+): "([^"]+)"$/ do |klass, method, value|
  model(klass).reload.send(method).should == value
end
