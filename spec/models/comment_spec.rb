require 'spec_helper'

describe Comment do
  it "should create a new instance given valid attributes" do
    Factory.create(:comment)
  end

  describe "#details" do
    before(:each) do
      @comment = Factory(:comment)
    end

    describe "#voices" do
      it "should only have the original user as a voice" do
        @comment.voices.should == [@comment.user]
      end

      it "should not have any recipient voices" do
        @comment.recipient_voices.should be_empty
      end

      context "when multiple users in the discussion" do
        before(:each) do
          @comment2 = Factory(:comment, :commentable => @comment.commentable)
          @comment3 = Factory(:comment, :commentable => @comment.commentable)
        end

        it "should have multiple recipient voices" do
          @comment.voices.should == [@comment.user, @comment2.user, @comment3.user]
        end
      end
    end

    it "should set the item description to that of commentable" do
      @comment.item_description.should == @comment.commentable.item_description
    end

    it "should set item title to Comment on commentable" do
      @comment.item_title.should == "Comment on #{@comment.commentable.item_title}"
    end

    it "should set an appropriate wall caption" do
      @comment.wall_caption.should == @comment.comments
    end

    it "should set item link to the commentable item" do
      @comment.item_link.should == @comment.commentable
    end

    it "should be downvoteable" do
      @comment.downvoteable?.should be_true
    end

    it "should set valid crump_parents"
    it "should trigger async_comment_messenger"
  end

  describe "#forum_post" do
    it "should not be a forum_post by default" do
      Factory(:comment).forum_post?.should_not be_true
    end

    it "should be a forum post when created on a topic" do
      pending("Finish topic spec")
      comment = Factory(:comment, :commentable => Factory(:topic))
      comment.forum_post?.should be_true
    end
  end

end
