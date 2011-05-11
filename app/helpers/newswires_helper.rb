module NewswiresHelper
  def newswire_via_with_date newswire
    I18n.translate('newswires.via', :title => newswire.feed.title, :date => timeago((newswire.updated_at || newswire.created_at))).html_safe
  end
end
