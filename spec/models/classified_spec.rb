require 'spec_helper'

describe Classified do
  it "should create a new instance given valid attributes" do
    classified = Factory.create(:classified)
    classified.state.should == :unpublished
    classified.expires_at.should be > Time.now
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

    context "::STATE:: :unpublished" do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "unpublished")
      end

      it "switches to the available state when published!" do
        @classified.should_receive(:expire)
        @classified.should_receive(:set_published)
        @classified.published!
        @classified.state.should == :available
      end
    end

    context "::STATE:: :available" do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "available")
      end

      context "loaner item" do
        before(:each) do
          @classified.listing_type = "loan"
        end

        it "should be loanable" do
          @classified.loanable?.should be_true
        end

        it "should not be sellable" do
          @classified.sellable?.should_not be_true
        end

        it "should not be free" do
          @classified.free?.should_not be_true
        end

        it "should create the loaning for the user and the item"

        it "loans the item to a user" do
          @classified.loan_to! Factory(:user)
          @classified.state.should == :loaned_out
        end

        context "friends only" do
          it "should not be loanable to a non friend"
        end
      end

      context "sellable item" do
        before(:each) do
          @classified.listing_type = "sale"
        end

        it "should be sellable" do
          @classified.sellable?.should be true
        end

        it "should be sellable" do
          @classified.sold!
          @classified.state.should == :sold
        end

        it "should not be loanable" do
          @classified.loanable?.should_not be_true
        end

        it "should not be free" do
          @classified.free?.should_not be_true
        end
      end

      it "should be closeable"
      it "should be hideable"
      it "should auto expire" do
        @classified.update_attribute(:expires_at, 1.minute.ago)
        Classified.auto_expired.should_not be_empty
      end
    end

    context "::STATE:: :expired" do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "expired")
      end

      it "should be renewable" do
        pending("Needs to have working success callback")
        @classified.should_receive(:update_renewed)
        @classified.renewed!
        @classified.state.should == :available
      end

      it "should not auto expire" do
        @classified.update_attribute(:expires_at, 1.minute.ago)
        Classified.auto_expired.should be_empty
      end
    end

    context "::STATE:: :closed"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "closed")
      end

      it "should not auto expire" do
        @classified.update_attribute(:expires_at, 1.minute.ago)
        Classified.auto_expired.should be_empty
      end
    end

    context "::STATE:: :sold"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "sold")
      end

      it "should not auto expire" do
        @classified.update_attribute(:expires_at, 1.minute.ago)
        Classified.auto_expired.should be_empty
      end
    end

    context "::STATE:: :loaned_out"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "loaned_out")
      end

      it "becomes hidden when returned" do
        pending("Needs to have working success callback")
        @classified.should_receive(:update_renewed)
        @classified.returned!
        @classified.state.should == :hidden
      end

      it "should not have an expires_at ????"
      it "should be closeable" do
        @classified.closed!
        @classified.state.should == :closed
      end

      it "should not be sellable" do
        lambda {@classified.sold!}.should raise_error
      end

      it "should be hideable????"

      it "should not auto expire" do
        @classified.update_attribute(:expires_at, 1.minute.ago)
        Classified.auto_expired.should be_empty
      end
    end

    context "::STATE:: :hidden"do
      before(:each) do
        @classified = Factory(:classified, :aasm_state => "hidden")
      end

      it "should become available after unhide" do
        @classified.unhide!
        @classified.state.should == :available
      end

      it "should be closable" do
        @classified.closed!
        @classified.state.should == :closed
      end

      it "should auto expire" do
        @classified.update_attribute(:expires_at, 1.minute.ago)
        Classified.auto_expired.should_not be_empty
      end
    end

    describe "#auto_expire" do
      before(:each) do
        @classified = Factory(:classified, :expires_at => 1.minute.ago)
      end

      it "should be expired" do
        @classified.should have_expired
      end

      it "should find auto expired items" do
        Classified.auto_expired.should have_at_least(1).things
      end

      context "::STATE:: unpublished" do
        before(:each) do
          @classified.aasm_state = "unpublished"
        end

        it "should expire" do
          @classified.expired!.should be_true
        end
      end

      context "::STATE:: available" do
        before(:each) do
          @classified.aasm_state = "available"
        end

        it "should expire" do
          @classified.expired!.should be_true
        end
      end

      context "::STATE:: hidden" do
        before(:each) do
          @classified.aasm_state = "hidden"
        end

        it "should expire" do
          @classified.expired!.should be_true
        end
      end


    end

    describe "#expire_all" do
      before(:each) do
        @auto_expire = [
          Factory(:classified, :aasm_state => "unpublished"),
          Factory(:classified, :aasm_state => "available"),
          Factory(:classified, :aasm_state => "hidden")
        ]
        @no_auto_expire = [
          Factory(:classified, :aasm_state => "sold"),
          Factory(:classified, :aasm_state => "loaned_out"),
          Factory(:classified, :aasm_state => "expired"),
          Factory(:classified, :aasm_state => "closed")
        ]
      end

      it "should expire the appropriate items" do
        pending("FIXME")
        #Classified.with_state(:expired).should have(1).things
        Classified.auto_expire_all.should be_true
        #Classified.with_state(:expired).should have(4).things
        @auto_expire.each {|c| c.expired?.should be_true }
      end

      it "should not expire items that do not expire" do
        pending("FIXME")
        Classified.auto_expire_all.should be_true
        Classified.no_auto_expire.should have(3).things
      end
    end

  end # describe #statemachine

end
