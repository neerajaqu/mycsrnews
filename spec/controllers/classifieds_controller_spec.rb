require 'spec_helper'

describe ClassifiedsController do

  def access_denied(&block)
    block.call

    response.should redirect_to("http://test.host#{classifieds_path(:format => 'html')}")
    flash[:notice].should =~ /^Access Denied/
  end

  def access_allowed(&block)
    block.call

    flash[:notice].should be_nil
    response.should be_success
  end

  #Delete these examples and add some real ones
  it "should use ClassifiedsController" do
    controller.should be_an_instance_of(ClassifiedsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      @classified = Factory(:classified, :aasm_state => "available")
      stub(controller).current_user { nil }
      access_allowed { get :show, :id => @classified.id }
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      classified = Factory(:classified)
      stub(controller).current_user { classified.user }
      get :edit, :id => classified.id
      response.should be_success
    end
  end

  describe "#my_items" do
    before(:each) do
      @user = Factory(:user)
      stub(controller).current_user { @user }
    end

    describe "GET 'my_items'" do
      it "should be successful" do
        get 'my_items'
        response.should be_success
      end
    end

    describe "GET 'borrowed_items'" do
      it "should be successful" do
        get 'borrowed_items'
        response.should be_success
      end
    end
  end

  describe "#AUTH" do
    before(:each) do
      @classified = Factory(:classified)
    end

    context "admin user" do
      before(:each) do
        @user = Factory(:user)
        stub(controller).current_user { @user }
      end

      it "should be allowed for boolean field is_admin = true" do
        pending("overload has_role? :admin")
        @user.is_admin = true
        access_allowed { get :show, :id => @classified.id }
      end

      it "should be allowed for has_role admin" do
        @user.has_role! :admin
        access_allowed { get :show, :id => @classified.id }
      end
    end

    context "other user" do
      before(:each) do
        @user = Factory(:user)
        stub(controller).current_user { @user }
      end

      it "should not be allowed to friends only" do
        @classified.update_attribute(:allow, "friends")
        access_denied { get :show, :id => @classified.id }
      end
    end
  end
end
