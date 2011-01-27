require 'spec_helper'

describe IdeaBoard do
  it "should create a new instance given valid attributes" do
    Factory.create(:idea_board)
  end
end
