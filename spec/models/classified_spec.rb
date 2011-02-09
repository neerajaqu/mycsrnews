require 'spec_helper'

describe Classified do
  it "should create a new instance given valid attributes" do
    classified = Factory.create(:classified)
    classified.state.should == :unpublished
    classified.expires_at.should be > Time.now
  end

  describe "#named scopes" do
    describe "Classified.sale" do
      it "should return sale classifieds" do
        @classified = Factory(:sale_classified)
        Classified.for_sale.should include(@classified)
      end
    end

    describe "Classified.free" do
      it "should return free classifieds" do
        @classified = Factory(:free_classified)
        Classified.for_free.should include(@classified)
      end
    end

    describe "Classified.loan" do
      it "should return loan classifieds" do
        @classified = Factory(:loan_classified)
        Classified.for_loan.should include(@classified)
      end
    end

    describe "Classified.allow_all" do
      it "should return classifieds with allow all" do
        @classified = Factory(:available_classified, :allow => "all")
        Classified.allow_all.should include(@classified)
      end
    end

    describe "Classified.allow_friends" do
      it "should return classifieds with allow friends" do
        @classified = Factory(:available_classified, :allow => "friends")
        Classified.allow_friends.should include(@classified)
      end
    end

    describe "Classified.allow_friends_of_friends" do
      it "should return classifieds with allow friends_of_friends" do
        @classified = Factory(:available_classified, :allow => "friends_of_friends")
        Classified.allow_friends_of_friends.should include(@classified)
      end
    end

    describe "Classified.available" do
      it "should return availalbe classifieds" do
        @classified1 = Factory(:available_classified)
        @classified2 = Factory(:sale_classified)
        @classified3 = Factory(:free_classified)
        @classified4 = Factory(:loan_classified)
        Classified.available.should == [@classified1, @classified2, @classified3, @classified4]
      end
    end
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
        mock(@classified).expire
        mock(@classified).set_published
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
        mock(@classified).update_renewed
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
        mock(@classified).update_renewed
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

=begin
  describe "#sections" do
    before(:all) do
      @default_categories = [:pizza, :coffee, :oreos]
      @default_subcategories = [:delicious, :deal, :yum]

      @default_categories.each do |category|
        Classified.add_default_category(category)
      end

      @default_subcategories.each do |subcategory|
        Classified.add_default_subcategory(subcategory)
      end
    end

    it "should set appropriate categories" do
      @default_categories.each do |category|
        Classified.valid_category?(category).should be_true
      end
    end

    it "should not allow subcategories as valid categories" do
      @default_subcategories.each do |subcategory|
        Classified.valid_category?(subcategory).should be_false
      end
    end

    it "should set appropriate subcategories" do
      @default_subcategories.each do |subcategory|
        Classified.valid_subcategory?(subcategory).should be_true
      end
    end

    it "should not allow categories as valid subcategories" do
      @default_categories.each do |category|
        Classified.valid_subcategory?(category).should be_false
      end
    end
  end
=end

end
