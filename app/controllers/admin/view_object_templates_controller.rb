class Admin::ViewObjectTemplatesController < AdminController

  admin_scaffold :view_object_template do |config|
    config.index_fields = [:pretty_name]
    config.show_fields = [:pretty_name]
    config.actions = [:index, :show]
  end

end
