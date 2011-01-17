module PaginationHelper

  def get_page page = nil
    page.present? ? (page.to_i < 3 ? "page_#{page}_" : "") : "page_1_"
  end

  def add_pagination items = nil
  # TODO
  end

end
