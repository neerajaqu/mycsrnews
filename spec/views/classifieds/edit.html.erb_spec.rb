require 'spec_helper'

describe "/classifieds/edit" do
  before(:each) do
    render 'classifieds/edit'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    pending("spec views?")
    response.should have_tag('p', %r[Find me in app/views/classifieds/edit])
  end
end
