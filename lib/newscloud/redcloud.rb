module Newscloud
  module Redcloud

    def self.create(server = nil, namespace = nil)
      server ||= APP_CONFIG['redis']
      namespace ||= APP_CONFIG['namespace'] || 'newscloud'
      host, port, db = server.split(':')
      redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
      @redis = Redis::Namespace.new(namespace.to_sym, :redis => redis)
    end

  end
end
