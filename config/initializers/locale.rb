# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
I18n.load_path += Dir[File.join(RAILS_ROOT, 'config', 'locales', '**', '*.{rb,yml}')]
I18n.default_locale = :en
I18n.locale = :en
#I18n.backend == I18n::Backend::Database.new
#I18n.backend.cache_store = :memory_store
