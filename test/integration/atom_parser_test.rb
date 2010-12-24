require 'test_helper'

class AtomParserTest < ActiveSupport::TestCase

  test "should parse an atom feed" do
    feed = Feed.create!({
      :title => "Example atom feed",
      :url => "http://www.google.com/reader/public/atom/user/01679457246157955561/state/com.google/broadcast",
      :rss => "http://www.google.com/reader/public/atom/user/01679457246157955561/state/com.google/broadcast"
    })
    N2::FeedParser.update_feed feed

    assert feed.newswires.any?
  end

end
