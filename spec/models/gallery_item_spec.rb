require 'spec_helper'

describe GalleryItem do

  it "should create a new instance given valid attributes" do
    Factory.create(:gallery_item)
  end

  it "should require an item_url" do
    gallery_item = Factory.build(:gallery_item, :item_url => nil)
    gallery_item.should_not be_valid
    gallery_item.errors.on(:item_url).should_not be_nil
    gallery_item.item_url = "foo.jpg"
    gallery_item.should_not be_valid
    gallery_item.errors.on(:item_url).should_not be_nil
    gallery_item.item_url = "http://example.com/foo.jpg"
    gallery_item.should be_valid
  end

  it "should allow a youtube url" do
    youtube_video_id = "ZV-AFnCkRLY"
    gallery_item = Factory.build(:gallery_item, :item_url => "http://www.youtube.com/watch?v=#{youtube_video_id}")
    gallery_item.should be_valid
    gallery_item.save.should_not == false
    gallery_item.galleryable.should_not be_nil 
  end

  it "should not require a caption" do
    gallery_item = Factory.build(:gallery_item, :caption => nil)
    gallery_item.should be_valid
    gallery_item.errors.on(:caption).should be_nil
    gallery_item.caption = Faker::Lorem.paragraph
    gallery_item.should be_valid
  end

  describe "#details" do
    before(:each) do
      @title = "My awesome new gallery!"
      @caption = "This is the caption for My awesome new gallery!"
      @gallery_item = Factory(
        :gallery_item,
        :title   => @title,
        :caption => @caption
      )
    end

    it "should set a valid item_title" do
      @gallery_item.item_title.should == @title
    end

    it "should set a valid item_caption" do
      @gallery_item.item_description.should == @caption
    end

    it "should have a valid user" do
      @gallery_item.user.should == @gallery_item.gallery.user
    end

    it "should have a valid user in galleryable" do
      @gallery_item.galleryable.user.should == @gallery_item.gallery.user
    end
  end

  describe "#youtube video" do
    before(:each) do
      @youtube_video_id = "wMFPe-DwULM"
      @url = "http://www.youtube.com/watch?v=#{@youtube_video_id}"
      @title = "Feynman 'Fun to Imagine' 4: Magnets (and 'Why?' questions...)"
      @caption = "Physicist Richard Feynman explains to a non-scientist just how difficult it is to answer certain questions in lay terms! A classic example of Feynman's clarity of thought, powers of explanation and intellectual honesty - and his refusal to 'cheat' with misleading analogies...\r\nFrom the BBC TV series 'Fun to Imagine'(1983). You can now watch higher quality versions of some of these episodes at www.bbc.co.uk/archive/feynman/"
      @gallery_item = Factory(:gallery_item, :item_url => @url)
    end

    it "should have a video as galleryable" do
      @gallery_item.galleryable.class.should == Video
    end

    it "should have a youtube video as galleryable" do
      @gallery_item.galleryable.youtube_video?.should be_true
    end

    it "should have a valid remote_video_id" do
      @gallery_item.galleryable.remote_video_id.should == @youtube_video_id
    end

    it "should have a valid title" do
      @gallery_item.item_title.should == @title
    end

    it "should have a valid caption" do
      @gallery_item.item_description.should == @caption
    end

    it "should have a valid full url" do
      @gallery_item.full_url.should == @url
    end

    it "should have a valid thumb url" do
      @gallery_item.thumb_url.should == "http://i.ytimg.com/vi/#{@youtube_video_id}/default.jpg"
    end

    it "should have a valid item url" do
      @gallery_item.item_url.should == @url
    end
  end

  describe "#vimeo video" do
    before(:each) do
      @vimeo_video_id = "10529973"
      @url = "http://vimeo.com/#{@vimeo_video_id}"
      @title = "Functional Fluid Dynamics in Clojure"
      @caption = "Please read this http://www.bestinclass.dk/index.php/2010/03/functional-fluid-dynamics-in-clojure/"
      @gallery_item = Factory(:gallery_item, :item_url => @url)
    end

    it "should have a video as galleryable" do
      @gallery_item.galleryable.class.should == Video
    end

    it "should have a vimeo video as galleryable" do
      @gallery_item.galleryable.vimeo_video?.should be_true
    end

    it "should have a valid remote_video_id" do
      @gallery_item.galleryable.remote_video_id.should == @vimeo_video_id
    end

    it "should have a valid title" do
      @gallery_item.item_title.should == @title
    end

    it "should have a valid caption" do
      @gallery_item.item_description.should == @caption
    end

    it "should have a valid full url" do
      @gallery_item.full_url.should == @url
    end

    it "should have a valid thumb url" do
      @gallery_item.thumb_url.should_not be_nil
      @gallery_item.thumb_url.should match valid_url_regex
    end

    it "should have a valid item url" do
      @gallery_item.item_url.should == @url
    end
  end
end
