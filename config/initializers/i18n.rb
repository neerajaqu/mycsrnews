I18n.backend = I18n::Backend::Database.new # registers the backend
# leave the cache store to whatever cache store is currently being used
#I18n.backend.cache_store = :memory_store   # optional: specify an alternate cache store
#I18n.backend.localize_text_tag = '##'      # optional: specify an alternate localize text tag, the default is ^^
