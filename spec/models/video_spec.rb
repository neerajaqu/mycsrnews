require 'spec_helper'

describe Video do

  it "should create a new instance given valid attributes" do
    Factory.create(:video)
  end

  it "should find the info for youtube videos" do
    youtube_video_id = "ObR3qi4Guys"
    video = Factory.create(:video, :remote_video_url => "http://www.youtube.com/watch?v=#{youtube_video_id}")
    video.should be_valid
    video.title.should_not be_nil
    video.description.should_not be_nil
    video.thumb_url.should == "http://i.ytimg.com/vi/#{youtube_video_id}/default.jpg"
    video.full_url.should == "http://www.youtube.com/watch?v=#{youtube_video_id}"
  end

  it "should find the info for vimeo videos" do
    vimeo_video_id = "9090935"
    video = Factory.create(:video, :remote_video_url => "http://vimeo.com/#{vimeo_video_id}")
    video.should be_valid
    video.title.should_not be_nil
    video.description.should_not be_nil
    video.thumb_url.should_not be_nil
    video.full_url.should == "http://vimeo.com/#{vimeo_video_id}"
  end

end
