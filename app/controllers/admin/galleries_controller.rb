class Admin::GalleriesController < AdminController

  admin_scaffold :gallery do |config|
    config.index_fields = [:title, :description, :user_id]
    config.actions = [:index, :show, :edit]
    config.associations = { :belongs_to => { :user => :user_id } }
  end

end
