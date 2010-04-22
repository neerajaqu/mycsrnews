atom_feed do |feed|
  feed.title(APP_CONFIG['site_title'])
  feed.updated(@contents.first.created_at)

  @contents.each do |story|
    feed.entry(story, :url => story_url(story, :format => 'html')) do |entry|
      entry.title(story.title)
      entry.content(story.caption, :type => 'html', :url => story_url(story, :format => 'html'))
      entry.author { |author| author.name(story.user.public_name) }
    end
  end
end
