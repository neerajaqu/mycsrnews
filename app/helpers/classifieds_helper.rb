module ClassifiedsHelper
  def allow_type_select
    select_tag 'allow_type', options_for_select(Classified.allow_types.map {|c| [c.to_s.humanize, c] }.unshift(['Any', 'any']))
  end

  def listing_type_select
    select_tag 'listing_type', options_for_select(Classified.listing_types.map {|c| [t("classifieds.listing_type_strings.#{c}"), c] }.unshift(['Any', 'any']))
  end

  def classified_actions classified
    classified.valid_user_events.map {|e| [t("classifieds.actions.#{e.to_s}"), set_status_classified_path(classified, :status => e.to_s)] }
  end

  def classified_listing_type(classified)
    if classified.sellable?
      I18n.translate("classifieds.listing_type_strings.sale_with_price", :price => number_to_currency(classified.price) )
    else
      I18n.translate("classifieds.listing_type_strings.#{classified.listing_type}")
    end
  end

  def classifieds_posted_by classified
    I18n.translate('posted_by_in_category', :fb_name => local_linked_profile_name(classified.user), :date => timeago(classified.created_at), :category => classified.category_name).html_safe
  end

end
