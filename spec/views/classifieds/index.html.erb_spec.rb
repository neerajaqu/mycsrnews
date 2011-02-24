require 'spec_helper'

describe "/classifieds/index" do
  before(:each) do
    render 'classifieds/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    pending("spec views?")
    response.should have_tag('p', %r[Find me in app/views/classifieds/index])
  end
end
