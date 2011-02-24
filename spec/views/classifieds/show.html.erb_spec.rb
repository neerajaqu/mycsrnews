require 'spec_helper'

describe "/classifieds/show" do
  before(:each) do
    #render 'classifieds/show'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    pending("spec views?")
    response.should have_tag('p', %r[Find me in app/views/classifieds/show])
  end
end
