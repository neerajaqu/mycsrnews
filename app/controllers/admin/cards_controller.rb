class Admin::CardsController < AdminController

  admin_scaffold :card do |config|
    config.index_fields = [:name, :short_caption, :long_caption]
    config.new_fields   = [:name, :short_caption, :long_caption, lambda {|f| f.input :image, :as => :file }]
    config.edit_fields  = [:name, :short_caption, :long_caption]
    config.actions      = [:index, :show, :edit, :new, :create, :update]
    config.media_form   = true
  end

end
