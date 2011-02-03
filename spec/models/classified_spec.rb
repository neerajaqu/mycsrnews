require 'spec_helper'

describe Classified do
  it "should create a new instance given valid attributes" do
    classified = Factory.create(:classified)
    classified.state.should == "unpublished"
  end

  describe "#state_machine" do
    before(:each) do
      @classified = Factory(:classified)
    end

    it "should have votes_count"
    it "should have comments_count"
    it "should be in the unpublished state" do
      @classified.unpublished?.should be_true
    end

    context "state :unpublished" do
      it "switches to the available state when published!" do
        #@classified.should_receive(:expire).should_receive(:set_published)
        @classified.should_receive(:expire)
        @classified.should_receive(:set_published)
        @classified.published!
        @classified.aasm_current_state.should == :available
      end
    end


    context "state :available" do
      before(:each) do
        @classified.published!
      end

      context "loaner item" do
        it "should be loanable"
        it "should create the loaning for the user and the item"

        context "state: available" do
          it "loans the item to a user" do
            @classified.should_receive(:loaned_out!)
            @classified.loan_to Factory(:user)
          end
        end

        context "state: loaned_out" do
          before(:each) do
            @classified.loan_to Factory(:user)
          end

          it "becomes available when returned" do
            pending("Needs to have working success callback")
            @classified.should_receive(:update_renewed)
            @classified.returned!
          end
        end

      end

    end

    context "state :expired" do
      before(:each) do
        @classified.expired!
      end

      it "should be renewable" do
        pending("Needs to have working success callback")
        @classified.should_receive(:update_renewed)
        @classified.renewed!
        @classified.aasm_current_state.should == :available
      end
    end
  end
end
