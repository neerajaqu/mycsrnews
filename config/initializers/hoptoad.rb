if APP_CONFIG and APP_CONFIG['hoptoad_api_key'].present?
  HoptoadNotifier.configure do |config|
    config.api_key = APP_CONFIG['hoptoad_api_key']
  end
end
