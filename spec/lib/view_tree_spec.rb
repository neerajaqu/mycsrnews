require "spec_helper"

describe ViewTree do

  it "should render" do
    mock(ViewTree).fetch("stories--index")
    controller = StoriesController.new
    controller.action_name = 'index'
    ViewTree.render controller
  end

  describe "#fetch" do
    context "item is cached" do
      before(:each) do
        mock($redis).get(anything) { true }
        mock(ViewObject).load(anything).times(0)
        @key_name = "stories--index"
      end

      it "should fetch" do
        ViewTree.fetch(@key_name)
      end
    end

    context "item is not cached" do
      before(:each) do
        @key_name = "stories--index"
        mock(ViewObject).load(@key_name) { true }
        mock($redis).get(@key_name) { nil }
      end

      it "should fetch" do
        ViewTree.fetch(@key_name)
      end
    end
  end
end
