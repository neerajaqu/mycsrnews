namespace :i18n do

  namespace :populate do
    desc 'Update the locales and translations tables from all Rails Locale YAML files. This will leave existing locales alone.'
    task :update_from_rails => :environment do
      yaml_files = ENV['LOCALE_YAML_FILES'] ? ENV['LOCALE_YAML_FILES'].split(',') : I18n.load_path
      yaml_files.each do |file|
        I18nUtil.update_from_yml file
      end
    end
  end

  namespace :populate do
    desc 'Updates and synchronizes'
    task :update_and_sync => [:update_from_rails,:synchronize_translations] do
    end
  end

end
