class Admin::MetadataController < AdminController
  def index
  end

  private

  def set_current_tab
    @current_tab = 'metadatas'
  end

end
