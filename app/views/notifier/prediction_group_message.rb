== #{@prediction_group.user.name} suggested prediction topic "#{@prediction_group.item_title}"
%br
%a{:href=> polymorphic_url(@prediction_group.item_link, :only_path => false) }= I18n.translate('message.visit_item')
