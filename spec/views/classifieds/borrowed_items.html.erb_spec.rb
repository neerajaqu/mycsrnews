require 'spec_helper'

describe "/classifieds/borrowed_items" do
  before(:each) do
    render 'classifieds/borrowed_items'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/classifieds/borrowed_items])
  end
end
