require 'test_helper'

class ContentTest < ActiveSupport::TestCase

  test "should create content" do
    assert_difference 'Content.count' do
      content = create_content
      assert !content.new_record?, "#{content.errors.full_messages.to_sentence}"
    end
  end

  test "should require title" do
    assert_no_difference 'Content.count' do
      content = create_content(:title => nil)
      assert content.errors.on(:title)
    end
  end

  test "should require url" do
    assert_no_difference 'Content.count' do
      content = create_content(:url => nil)
      assert content.errors.on(:url)
    end
  end

  test "should require user_id" do
    assert_no_difference 'Content.count' do
      content = create_content(:user_id => nil)
      assert content.errors.on(:user_id)
    end
  end

  test "should require caption" do
    assert_no_difference 'Content.count' do
      content = create_content(:caption => nil)
      assert content.errors.on(:caption)
    end
  end

  test "should not require image_url" do
    assert_difference 'Content.count' do
      content = create_content(:image_url => nil)
      assert !content.new_record?
    end
  end

  test "should not require tag_list" do
    assert_difference 'Content.count' do
      content = create_content(:tag_list => nil)
      assert !content.new_record?
    end
  end

  protected

  def create_content(options = {})
    record = Content.new({
    	:title  => Faker::Company.catch_phrase,
    	:url    => "http://#{Faker::Internet.domain_name}",
    	:image_url  => "http://#{Faker::Internet.domain_name}/foo.jpg",
    	:tag_list   => "pizza, coffee, foo, bar",
    	:caption    => Faker::Lorem.paragraph,
    	:user_id    => 1
    }.merge(options))
    record.save
    record
  end
end
