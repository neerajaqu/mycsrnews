hoptoad_api_key = Metadata::Setting.table_exists? ? ( Metadata::Setting.find_setting('hoptoad_api_key').try(:value) || APP_CONFIG['hoptoad_api_key'] ) : nil

if hoptoad_api_key 
  HoptoadNotifier.configure do |config|
    config.api_key = hoptoad_api_key
  end
end
