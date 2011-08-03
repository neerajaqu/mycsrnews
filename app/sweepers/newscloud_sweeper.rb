#
# Base Newscloud Sweeper; extend from this
#
class NewscloudSweeper < ActionController::Caching::Sweeper
  def expire(item = nil) end
  def expire_all(item = nil) end
  def self.expire(item = nil) end
  def self.expire_all(item = nil) end

  def self.expire_class klass, namespace = nil
    namespace ||= '*'
    key = "#{klass.name.downcase}:view_object_namespace_deps:#{namespace}"
    keys = $redis.keys(key)

    #return $redis.sunion(*($redis.keys(key))).map {|vo_name| vo_name.split(/:/).inject(nil) {|m,id| m.nil? ? id.classify.constantize : m.find(id) } }
    if keys.any?
      $redis.sunion(*(keys)).each do |key_name|
        if key_name =~ /^view_object:([0-9]+)$/
          view_object = ViewObject.find($1)
          view_object.uncache_deps
        end
      end
    end
  end

  def self.expire_instance item
    keys = $redis.keys(item.model_deps_key)
    if keys.any?
      $redis.sunion(item.model_deps_key).each do |key_name|
        if key_name =~ /^view_object:([0-9]+)$/
          view_object = ViewObject.find($1)
          view_object.uncache_deps
        end
      end
    end

    # TODO:: stop this
    return self.expire_class(item.class)
  end
end
