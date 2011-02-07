require 'spec_helper'

describe Question do
  it "should create a new instance given valid attributes" do
    Factory.create(:question)
  end

  it "should appropriately set valid refine type?"
  it "should appropriately set refineable select options"
  it "should have a valid featured related locale (REMOVE THIS??)"

  describe "#featured_related_count" do
    context "when no answers" do
      before(:each) do
        @question = Factory(:question)
      end

      it "returns 0 for featured related count" do
        @question.featured_related_count.should == 0
      end
    end

    context "when answers are present" do
      before(:each) do
        @question = Factory(:question)
        @answer = Factory.create(:answer, :question => @question)
      end

      it "returns 1 for featured related count" do
        @question.reload.featured_related_count.should == 1
      end
    end
  end

end
