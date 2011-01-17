require 'spec_helper'

describe Gallery do
  it "should create a new instance given valid attributes" do
    Factory.create(:gallery)
  end

  it "should require a title" do
    gallery = Factory.build(:gallery, :title => nil)
    gallery.should_not be_valid
    gallery.errors.on(:title).should_not be_nil
    gallery.title = Faker::Company.catch_phrase
    gallery.should be_valid
  end

  it "should require a description" do
    gallery = Factory.build(:gallery, :description => nil)
    gallery.should_not be_valid
    gallery.errors.on(:description).should_not be_nil
    gallery.description = Faker::Lorem.paragraph
    gallery.should be_valid
  end

  it "should require a user" do
    gallery = Factory.build(:gallery, :user => nil)
    gallery.should_not be_valid
    gallery.errors.on(:user).should_not be_nil
    gallery.user = Factory(:user)
    gallery.should be_valid
  end

  describe "#details" do
    before(:each) do
      @gallery = Factory(:gallery)
      @gallery_item = Factory.create(:gallery_item, :gallery => @gallery, :user => @gallery.user)
    end

    it "should return the highest positioned gallery item's thumb_url for thumb_url" do
      @gallery.thumb_url.should == @gallery.gallery_items.positioned.first.thumb_url
    end

    it "should return the highest positioned gallery item's full_url for full_url" do
      @gallery.full_url.should == @gallery.gallery_items.positioned.first.full_url
    end

    context "when there is only one gallery contributor" do
      it "should return the gallery user for gallery voices" do
        @gallery.user_voices.count.should == 1
        @gallery.user_voices.include?(@gallery.user).should be_true
      end
    end

    context "when there is more than one gallery contributor" do
      before(:each) do
        @gallery_item = Factory.create(:gallery_item, :gallery => @gallery, :user => Factory(:user))
      end

      it "should return the contributors for gallery voices" do
        @gallery.user_voices.count.should == 2
        @gallery.user_voices.include?(@gallery.user).should be_true
        @gallery.user_voices.include?(@gallery_item.user).should be_true
      end

      it "should not return duplicate contributors for gallery voices" do
        @gallery_item = Factory.create(:gallery_item, :gallery => @gallery, :user => @gallery_item.user)
        @gallery_item = Factory.create(:gallery_item, :gallery => @gallery, :user => @gallery_item.user)
        @gallery_item = Factory.create(:gallery_item, :gallery => @gallery, :user => @gallery_item.user)
        @gallery.gallery_items.count.should == 5
        @gallery.user_voices.count.should == 2
        @gallery.user_voices.include?(@gallery.user).should be_true
        @gallery.user_voices.include?(@gallery_item.user).should be_true
      end
    end
  end

  describe "#build from youtube playlist" do
    describe "both full playlist urls and playlist ids should work" do
      it "should work with a full playlist url" do
        Gallery.build_from_youtube_playlist("http://www.youtube.com/view_play_list?p=E18841CABEA24090", Factory(:user)).should_not be_nil
      end

      it "should work with a playlist id" do
        Gallery.build_from_youtube_playlist("E18841CABEA24090", Factory(:user)).should_not be_nil
      end
    end

    context "With valid data" do
      before(:all) do 
        @gallery = Gallery.build_from_youtube_playlist "http://www.youtube.com/view_play_list?p=E18841CABEA24090", Factory(:user)
      end

      it "should be valid" do
        @gallery.valid?.should be_true
      end

      it "should have a valid title" do
        @gallery.title.should == "MIT 6.001 Structure and Interpretation, 1986"
      end

      it "should have a valid description" do
        @gallery.description.should == "This course introduces students to the principles of computation. Upon completion of 6.001, students should be able to explain and apply the basic methods from programming languages to analyze computational systems, and to generate computational solutions to abstract problems. Substantial weekly programming assignments are an integral part of the course.\n\nThese twenty video lectures by Hal Abelson and Gerald Jay Sussman are a complete presentation of the course, given in July 1986 for Hewlett-Packard employees, and professionally produced by Hewlett-Packard Television. These videos are also available here under a Creative Commons license compatible with commercial use."
      end

      it "should have all the videos" do
        @gallery.gallery_items.count.should == 20
      end
    end

    context "Without valid data" do
      it "should return nil without a user" do
        Gallery.build_from_youtube_playlist("http://www.youtube.com/view_play_list?p=E18841CABEA24090").should be_nil
      end

      it "should be nil with a bad playlist url or id" do
        Gallery.build_from_youtube_playlist("http://www.youtube.com/view_play_listTYPOp=E18841CABEA24090").should be_nil
      end
    end
  end
end
