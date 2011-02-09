== Your classified item: #{@classified.item_title} listing has expired
%br
%a{:href=> polymorphic_url(@classified.item_link, :only_path => false) }= I18n.translate('message.visit_item')
