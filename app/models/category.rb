class Category < ActiveRecord::Base

  belongs_to :parent, :class_name => "Category"
  has_many :subcategories, :class_name => "Category", :foreign_key => :parent_id

  named_scope :default_categories, { :conditions => { :parent_id => nil, :categorizable_type => nil } }
  named_scope :default_categories_on, lambda {|klass| { :conditions => { :parent_id => nil, :categorizable_type => klass.name } } }
  named_scope :default_subcategories, { :conditions => ["parent_id IS NOT NULL AND categorizable_type IS NULL"] }
  named_scope :default_subcategories_on, lambda {|klass| { :conditions => ["parent_id IS NOT NULL AND categorizable_type = ?", klass.name] } }

  def subcategory?() not parent.nil? end
  def category?() parent.nil? end

  def add_subcategory name
    subcategories.build(:name => name, :categorizable_type => categorizable_type)
  end

  def add_subcategory! name
    sub = add_subcategory name
    save
    sub
  end

  def self.add_default_category name
    create!(:name => name)
  end

  def self.add_default_category_for klass, name
    create!(:categorizable_type => klass.name, :name => name)
  end

  def self.find_for_model_and_id klass, id
    self.find(:first, :conditions => { :id => id, :categorizable_type => klass })
  end

end
