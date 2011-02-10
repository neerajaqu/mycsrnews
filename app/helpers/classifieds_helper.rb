module ClassifiedsHelper
  def allow_type_select
    select_tag 'allow_type', options_for_select(Classified.allow_types.map {|c| [c.to_s.humanize, c] }.unshift(['Any', 'any']))
  end

  def listing_type_select
    select_tag 'listing_type', options_for_select(Classified.listing_types.map {|c| [c.to_s.humanize, c] }.unshift(['Any', 'any']))
  end
end
