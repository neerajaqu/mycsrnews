== Your classified item listing #{@classified.item_title} is nearing expiration
%br
%a{:href=> polymorphic_url(@classified.item_link, :only_path => false) }= I18n.translate('message.visit_item')
