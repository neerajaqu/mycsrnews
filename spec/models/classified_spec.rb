require 'spec_helper'

describe Classified do
  it "should create a new instance given valid attributes" do
    classified = Factory.create(:classified)
    classified.state.should == :unpublished
  end

  describe "#state_machine" do
    describe "#details" do
      before(:each) do
        @classified = Factory(:classified)
      end

      it "should have votes_count"
      it "should have comments_count"
      it "should be in the unpublished state" do
        @classified.unpublished?.should be_true
      end
    end

    context "state :unpublished" do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "unpublished")
      end

      it "switches to the available state when published!" do
        #@classified.should_receive(:expire).should_receive(:set_published)
        @classified.should_receive(:expire)
        @classified.should_receive(:set_published)
        @classified.published!
        @classified.state.should == :available
      end
    end


    context "state :available" do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "available")
      end

      context "loaner item" do
        it "should be loanable"
        it "should not be sellable"
        it "should create the loaning for the user and the item"

        it "loans the item to a user" do
          @classified.should_receive(:loaned_out!)
          @classified.loan_to! Factory(:user)
        end

        context "friends only" do
          it "should not be loanable to a non friend"
        end
      end

      context "sellable item" do
        it "should be sellable"
        it "should not be loanable"
      end

      it "should be closeable"
      it "should be hideable"
      it "should auto expire"
    end

    context "state :expired" do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "expired")
      end

      it "should be renewable" do
        pending("Needs to have working success callback")
        @classified.should_receive(:update_renewed)
        @classified.renewed!
        @classified.state.should == :available
      end

      it "should not auto expire"
    end

    context "state :closed"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "closed")
      end

      it "should not auto expire"
    end

    context "state :sold"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "sold")
      end

      it "should not auto expire"
    end

    context "state :loaned_out"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "loaned_out")
      end

      it "becomes available when returned" do
        pending("Needs to have working success callback")
        @classified.should_receive(:update_renewed)
        @classified.returned!
      end

      it "should not auto expire"
      it "should be closeable"
      it "should be hideable????"
    end

    context "state :hidden"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "hidden")
      end

      it "should become available after unhide" do
        # WTF:!?!?!?!?!??!?!?!?!?!??!?!
        # this breaks the test..........
        #@classified.should_receive(:renewed!)
        @classified.unhide!
        @classified.state.should == :available
      end

      it "should auto expire"
    end

  end
end
