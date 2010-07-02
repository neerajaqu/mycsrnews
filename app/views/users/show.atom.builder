atom_feed do |feed|
  feed.title(APP_CONFIG['site_title'])
  feed.updated(@activities.first.created_at)

  @activities.each do |activity|
    feed.entry(activity.participant.cache_key.to_s, :url => polymorphic_url(activity.participant.item_link, :only_path => false, :format => :html)) do |entry|
      entry.title(activity.participant.item_title)
      entry.summary(activity.participant.item_description)
      entry.author { |author| author.name(@user.public_name) }
    end
  end
end
