module CacheHelper

  def cache_if(bool, *args, &block)
    bool ? cache(args, &block) : yield
  end

end
