class Translation

  named_scope :with_type, lambda { |type|
    return {} if type.nil?
    { :conditions => ["raw_key LIKE ?", "#{type}%"] }
  }

end

I18nUtil.class_eval do

  # Create tanslation records from the YAML file.  Will create the required locales if they do not exist.
  def self.update_from_yml(file_name)
    puts "Loading #{file_name}"
    data = YAML::load(IO.read(file_name))
    data.each do |code, translations| 
      locale = Locale.find_or_create_by_code(code)
      backend = I18n::Backend::Simple.new
      keys = self.extract_i18n_keys(translations)
      keys.each do |key|
        value = backend.send(:lookup, code, key)

        pluralization_index = 1

        if key.ends_with?('.one')
          key.gsub!('.one', '')
        end

        if key.ends_with?('.other')
          key.gsub!('.other', '')
          pluralization_index = 0
        end

        if value.is_a?(Array)
          value.each_with_index do |v, index|
            create_translation(locale, "#{key}", index, v) unless v.nil?
          end
        else
          create_translation_without_update(locale, key, pluralization_index, value)
        end

      end
    end
  end

  # Finds or creates a translation record and updates the value
  def self.create_translation_without_update(locale, key, pluralization_index, value)
    translation = locale.translations.find_by_key_and_pluralization_index(Translation.hk(key), pluralization_index) # find existing record by hash key
    unless translation # or build new one with raw key
      translation = locale.translations.build(:key =>key, :pluralization_index => pluralization_index)
      puts "from yaml create translation for #{locale.code} : #{key} : #{pluralization_index}" unless RAILS_ENV['test']
    end
    unless (translation.value.present? and translation.value != translation.raw_key)
      translation.value = value
      translation.save!
      translation.send(:update_cache)
    end
  end

end