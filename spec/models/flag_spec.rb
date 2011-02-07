require 'spec_helper'

describe Flag do
  it "should create a new instance given valid attributes" do
    Factory.create(:flag)
  end

  it "should create a new instance given valid attributes for a model without flags_count" do
    pending "This does not currently work without a flags_count, conditional counter_cache?"
    Factory.create(:flag, :flaggable => Factory(:video))
  end

  describe "#valid flag types" do
    it "should set valid flag types" do
      Flag.flag_types.each do |flag_type|
        Flag.valid_flag_type?(flag_type).should be_true
      end
    end

    it "should not allow invalid flag types" do
      ['foo', 'bar', 'asdf', 'pizza'].each do |flag_type|
        Flag.valid_flag_type?(flag_type).should_not be_true
      end
    end
  end

  describe "#flaggable" do
    before(:each) do
      @flag = Factory(:flag)
    end

    it "should set item title to the flaggable model" do
      @flag.item_title.should == @flag.flaggable.item_title
    end

    it "should set item description to the flaggable model" do
      @flag.item_description.should == @flag.flaggable.item_description
    end

    describe "is_blocked" do
      it "should delegate is_blocked to the flaggable model" do
        pending("Remove this method in replace of predecate method")
      end

      it "should delegate is_blocked? to the flaggable model" do
        @flag.is_blocked?.should == @flag.flaggable.is_blocked?
        @flag.is_blocked?.should be_false
      end

      context "given a blocked flaggable item" do
        it "is_blocked? returns true" do
          @flag.flaggable.toggle_blocked
          @flag.is_blocked?.should == @flag.flaggable.is_blocked?
          @flag.is_blocked?.should be_true
        end
      end
    end
  end

  describe "#num_flags" do
    context "with flags_count counter cache field" do
      it "returns the appropriate number of flags" do
        pending("FIXME")
        @flag = Factory(:flag)
        #5.times { Factory(:flag, :flaggable => @flag.flaggable) }
        @flag.num_flags.should == 6
      end
    end

    context "without flags_count counter cache field" do
      it "returns the appropriate number of flags"
    end
  end

end
