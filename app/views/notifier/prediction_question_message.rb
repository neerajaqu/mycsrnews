== #{@prediction_question.user.name} suggested prediction "#{@prediction_question.item_title}"
%br
%a{:href=> polymorphic_url(@prediction_question.item_link, :only_path => false) }= I18n.translate('message.visit_item')
