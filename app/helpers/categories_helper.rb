module CategoriesHelper

  def categories_select klass = nil
    categories = klass ? klass.categories : Category.default_categories
    select_tag 'categories', options_for_select(categories.map {|c| [c.name.humanize, c.id] }.unshift(['All','all']))
  end

  def subcategories_select klass = nil
    subcategories = klass ? klass.subcategories : Category.default_subcategories
    select_tag 'subcategories', options_for_select(subcategories.map {|c| [c.name.humanize, c.id] }.unshift(['All','all']))
  end

end
