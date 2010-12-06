require 'test_helper'

class ParsePageTest < ActiveSupport::TestCase

  def setup
    super
    @file = File.join(FILES_DIR, 'html1.html')
    @file2 = File.join(FILES_DIR, 'html2.html')
    @results = Parse::Page.parse_page @file, true
  end

  test "should read file" do
    assert_not_nil @results
  end

  test "should have a title" do
    assert @results[:title].present?
    assert_equal @results[:title], "Test Parse Page Title"
  end

  test "should have a description" do
    assert @results[:description].present?
    assert_equal @results[:description], "Description tag in meta:description"
  end

  test "should have a description with http-equiv" do
    results = Parse::Page.parse_page @file2, true
    assert results[:description].present?
    assert_equal results[:description], "Description tag in http-equiv:description"
  end

  test "should have images" do
    assert @results[:images].any?
  end

  test "should have sized images" do
    assert @results[:images_sized].any?
  end

end
