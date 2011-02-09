require 'spec_helper'

describe Category do
  it "should create a new category given valid attributes" do
    category = Factory(:category)
    Category.default_categories.should include(category)
  end

  it "should create a new subcategory given valid attributes" do
    subcategory = Factory(:subcategory)
    Category.default_subcategories.should include(subcategory)
  end

  describe "#default_categories" do
    before(:each) do
      @category = Factory(:category)
    end

    it "should have default categories" do
      Category.default_categories.should include(@category)
    end

    context "on Classified" do
      before(:each) do
        @category = Factory(:category, :categorizable_type => Classified.name)
      end

      it "should create a valid category within the model scope" do
        category = Category.add_default_category_for Classified, Faker::Company.bs
        Category.default_categories_on(Classified).should include(category)
        Category.default_categories.should_not include(category)
      end

      it "should create a valid subcategory within the model scope" do
        subcategory = @category.add_subcategory! Faker::Company.bs
        Category.default_subcategories.should_not include(subcategory)
        Category.default_subcategories_on(Classified).should include(subcategory)
      end
    end
  end

  describe "#acts_as_categorizable" do
    it "classified should be categorizable" do
      Classified.categorizable?.should be_true
    end

    it "should create a valid category within the model scope" do
      category = Classified.add_category Faker::Company.bs
      Classified.categories.should include(category)
      Category.default_categories.should_not include(category)
    end

    it "should create a valid subcategory within the model scope" do
      category = Category.add_default_category_for Classified, Faker::Company.bs
      subcategory = category.add_subcategory! Faker::Company.bs
      Classified.subcategories.should include(subcategory)
      Category.default_subcategories.should_not include(subcategory)
    end

    it "should add a category to a classified"
    it "should add a subcategory to a category of a classified"
  end
end
