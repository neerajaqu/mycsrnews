require 'spec_helper'

describe Classified do
  it "should create a new instance given valid attributes" do
    Factory.create(:classified)
  end

  describe "#state_machine" do
    before(:each) do
      @classified = Factory(:classified)
    end

    it "should be in the unpublished state" do
      @classified.unpublished?.should be_true
    end

    context "state :unpublished" do
      it "switches to the available state when published!" do
        @classified.should_receive(:set_published)
        @classified.publish!
        @classified.aasm_current_state.should == :available
      end
    end


    context "state :available" do
      before(:each) do
        @classified.publish!
      end

      it "switches to the unpublished state when unpublished" do
        @classified.should_receive(:set_unpublish)
        @classified.unpublish!
        @classified.aasm_current_state.should == :unpublished
      end

      context "loaner item" do
        it "should be loanable"
        it "should create the loaning for the user and the item"

        context "state: available" do
          it "loans the item to a user" do
            @classified.should_receive(:loan_out!)
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
            @classified.return!
          end
        end

      end

    end

    context "state :expired" do
      before(:each) do
        @classified.expire!
      end

      it "should be renewable" do
        pending("Needs to have working success callback")
        @classified.should_receive(:update_renewed)
        @classified.renew!
        @classified.aasm_current_state.should == :available
      end
    end
  end
end
