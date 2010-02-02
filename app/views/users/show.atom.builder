atom_feed do |feed|
  feed.title(APP_CONFIG['site_title'])
  feed.updated(@actions.first.created_at)

  @actions.each do |action|
    feed.entry(action, :url => build_feed_link(action)) do |entry|
      entry.title(build_feed_title(action, @user))
      entry.action(build_feed_blurb(action, @user), :type => 'html', :url => build_feed_link(action))
      entry.author { |author| author.name(@user.name) }
    end
  end
end
