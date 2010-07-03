class SitemapWorker
  @queue = :sitemaps

  def self.perform()
    rake "-s sitemap:refresh"
  end

end
