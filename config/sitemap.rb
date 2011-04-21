# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = APP_CONFIG['base_site_url']

if Metadata::Setting.find_setting('yahoo_app_id').present?
  SitemapGenerator::Sitemap.yahoo_app_id = Metadata::Setting.find_setting('yahoo_app_id').value
end

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host


  # Examples:

  sitemap.add home_index_path, :priority => 0.8, :changefreq => 'daily'
  sitemap.add stories_path, :priority => 0.7, :changefreq => 'daily'
  sitemap.add events_path, :priority => 0.6, :changefreq => 'daily'
  sitemap.add forums_path, :priority => 0.6, :changefreq => 'daily'
  sitemap.add questions_path, :priority => 0.6, :changefreq => 'daily'
  sitemap.add ideas_path, :priority => 0.6, :changefreq => 'daily'
  sitemap.add resources_path, :priority => 0.6, :changefreq => 'daily'
  sitemap.add idea_boards_path, :priority => 0.5, :changefreq => 'daily'
  sitemap.add resource_sections_path, :priority => 0.5, :changefreq => 'daily'
  sitemap.add prediction_groups_path, :priority => 0.5, :changefreq => 'daily'
  # to do  add classified_ tag sections path
  
  Content.active.find(:all).each do |a|
    sitemap.add story_path(a), :lastmod => a.updated_at, :priority => 0.6
  end

  Idea.active.find(:all).each do |a|
    sitemap.add idea_path(a), :lastmod => a.updated_at
  end

  IdeaBoard.active.find(:all).each do |a|
    sitemap.add idea_board_path(a), :lastmod => a.updated_at, :priority => 0.4
  end

  Event.active.find(:all).each do |a|
    sitemap.add event_path(a), :lastmod => a.updated_at
  end

  Resource.find(:all).each do |a|
    sitemap.add resource_path(a), :lastmod => a.updated_at
  end

  ResourceSection.active.find(:all).each do |a|
    sitemap.add resource_section_path(a), :lastmod => a.updated_at, :priority => 0.4
  end

  Question.find(:all).each do |a|
    sitemap.add question_path(a), :lastmod => a.updated_at
  end

  Forum.find(:all).each do |a|
    sitemap.add forum_path(a), :lastmod => a.updated_at
  end

  PredictionGroup.active.find(:all).each do |a|
    sitemap.add prediction_group_path(a), :lastmod => a.updated_at, :priority => 0.4
  end

  PredictionQuestion.active.find(:all).each do |a|
    sitemap.add prediction_question_path(a), :lastmod => a.updated_at, :priority => 0.4
  end
  
  #todo add classified section pages
  Classified.active.find(:all).each do |a|
    sitemap.add classified_path(a), :lastmod => a.updated_at, :priority => 0.4
  end

end

# Including Sitemaps from Rails Engines.
#
# These Sitemaps should be almost identical to a regular Sitemap file except
# they needn't define their own SitemapGenerator::Sitemap.default_host since
# they will undoubtedly share the host name of the application they belong to.
#
# As an example, say we have a Rails Engine in vendor/plugins/cadability_client
# We can include its Sitemap here as follows:
#
# file = File.join(Rails.root, 'vendor/plugins/cadability_client/config/sitemap.rb')
# eval(open(file).read, binding, file)