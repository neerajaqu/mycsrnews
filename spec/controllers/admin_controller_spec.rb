require 'spec_helper'

describe AdminController do

  #Delete this example and add some real ones
  it "should use AdminController" do
    controller.should be_an_instance_of(AdminController)
  end

  it "should should allow scaffolding " do
    user_mock = double('User')
    controller.class.should_receive(:admin_scaffold_build_config)
    controller.class.admin_scaffold(:user)
  end

  describe "#Admin Scaffold" do
    context "should build the config" do
      it "should work with a block"
      it "should work with an options hash"
      it "should set options" do
        controller.class.admin_scaffold(:user)
        controller.admin_scaffold_config.should_not equal(OpenStruct.new)
      end
    end

    describe "#crud_operations" do
      it "should work for index, ..."
    end
  end

end
