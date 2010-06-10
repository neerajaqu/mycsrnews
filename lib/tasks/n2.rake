namespace :n2 do
  namespace :data do

    desc "Bootstrap and convert existing data"
    task :bootstrap => [:environment, :pre_register_users, :delete_floating_content, :delete_floating_comments, :delete_floating_ideas, :delete_floating_questions_and_answers, :update_floating_comments, :generate_model_slugs, :generate_widgets, :load_seed_data, :convert_images_to_paperclip, :load_locale_data] do
      puts "Finished Bootstrapping and converting existing data"
    end

    desc "Pre-Register existing users with facebook"
    task :pre_register_users => :environment do
      puts "Pre-Registering existing users with facebook"
      User.all.each do |user|
        next unless user.email.present?
        puts "\tRegistering #{user.name}(#{user.email})"
        begin
          user.register_user_to_fb
        rescue => e
          puts "\t***Failed to register user #{user.name}(#{user.email}) -- #{e}"
        end
      end
    end

    desc "Delete blank users"
    task :delete_blank_users => :environment do
      puts "Deleting blank users"
      User.find(:all, :conditions => ["name = ''"]).each do |user|
        user.user_profile.destroy if user.user_profile.present?
        user.destroy
      end
    end

    desc "Updating floating comments"
    task :update_floating_comments => :environment do
      puts "Updating floating comments"
      Comment.all.each do |comment|
        comment.commentable_type = 'Content'
        comment.save
      end
    end

    desc "Delete floating ideas"
    task :delete_floating_ideas => :environment do
      puts "Deleting floating ideas"
      count = 0
      Idea.all.each do |idea|
        idea.destroy and count += 1 if idea.user.nil?
      end
      puts "Deleted #{count} floating ideas"
    end

    desc "Delete floating questions_and_answers"
    task :delete_floating_questions_and_answers => :environment do
      puts "Deleting floating questions_and_answers"
      count = 0
      Question.all.each do |question|
        question.destroy and count += 1 if question.user.nil?
      end
      Answer.all.each do |answer|
        if answer.user.nil?
          answer.destroy and count += 1
        elsif answer.question.nil?
          answer.destroy and count += 1
        else
        	next
        end
      end
      puts "Deleted #{count} floating questions_and_answers"
    end

    desc "Delete Floating Content Posts"
    task :delete_floating_content => :environment do
      puts "Deleting floating contents"
      count = 0
      Content.all.each do |content|
        content.destroy and count += 1 unless content.user.present? and content.url.present? and valid_url?(content.url)
      end
      puts "Deleted #{count} floating contents"
    end

    desc "Delete Floating Comments"
    task :delete_floating_comments => :environment do
      puts "Deleting floating comments"
      count = 0
      Comment.all.each do |comment|
        comment.destroy and count += 1 unless comment.user.present?
      end
      puts "Deleted #{count} floating comments"
    end

    desc "Generate model slugs"
    task :generate_model_slugs => :environment do
      ['User', 'Content', 'IdeaBoard'].each do |model_name|
        puts "Creating slugs for #{model_name.titleize}"
        #Rake::Task['friendly_id:redo_slugs'].invoke ENV['MODEL']=model_name
        system("rake friendly_id:redo_slugs MODEL=#{model_name}")

        # Reenable friendly id tasks so they can be run in the next iteration
        #Rake::Task['friendly_id:redo_slugs'].reenable
        #Rake::Task['friendly_id:make_slugs'].reenable
        #Rake::Task['friendly_id:remove_old_slugs'].reenable
      end
    end

    desc "Generate widgets"
    task :generate_widgets => :environment do
      begin
        Rake::Task['n2:widgets:build'].invoke
      rescue Exception => e
        puts "Error processing widgets: #{e}"
      end
    end

    desc "Load Seed Data"
    task :load_seed_data => :environment do
      puts "Loading Seed Data"
      Rake::Task['db:seed'].invoke
    end

    desc "Load Locale Data"
    task :load_locale_data => :environment do
      puts "Loading Locale Data"
      Rake::Task['i18n:populate:load_default_locales'].invoke
      Rake::Task['i18n:populate:from_rails'].invoke
      Rake::Task['i18n:populate:synchronize_translations'].invoke
    end

    desc "Convert existing images to paperclip"
    task :convert_images_to_paperclip => :environment do
      puts "Converting images to paperclip format (this may take a while)"
      count = 0
      ContentImage.all.each do |image|
        next unless image.content.present? and image.url.present?
        next if image.content.images.present? and image.content.images.first.remote_image_url == image.url
        puts "\tConverting: #{image.url}"
        content = image.content
        content.images.build({:remote_image_url => image.url})
        if content.save
          count += 1
        else
        	puts "\t\tFailed to download image."
        end
      end
      puts "Finished converting #{count} images"
    end

    desc "Generate fake example data (takes an optional user_id param, otherwise defaults to first user"
    task :gen_fake_data => :environment do
      user = ENV['user_id'].present? ? User.find(ENV['user_id']) : User.first
      raise "Invalid user" unless user.present?

      item_count = ENV['item_count'] || 20
      model_generators = {
      	:content => Proc.new { {
      		:caption  => Faker::Lorem.paragraphs,
      		:url      => "http://#{Faker::Internet.domain_name}/articles/#{Faker::Company.catch_phrase}",
      		:title    => "#{Faker::Company.bs}",
      		:user     => user
        } },
      	:question => Proc.new { {
      		:question => "Do we need to #{Faker::Company.bs}?",
      		:details  => Faker::Lorem.paragraphs,
      		:user     => user
        } },
      	:answer => Proc.new { {
      		:answer   => "Perhaps, but what if we #{Faker::Company.bs}",
      		:question => Question.find(:first, :order => "RAND()"),
      		:user     => user
        } },
      	:comment => Proc.new { {
      		:comments => "I prefer #{Faker::Company.catch_phrase}.",
      		:commentable => Answer.find(:first, :order => "RAND()"),
      		:user     => user
        } }
      }
      model_generators.each do |model_name, model_generator|
        klass = model_name.to_s.classify.constantize
        item_count.times do
          klass.create model_generator.call
        end
      end
    end

    desc "Convert existing metadatas to have a type"
    task :update_metadata_types => :environment do
      Metadata.find(:all, :conditions => "type IS NULL").each do |metadata|
        if metadata.meta_type == 'config' and metadata.key_type == 'ads'
        	puts "Converting #{metadata.inspect} to Metadata::Ad type"
        	metadata.update_attribute(:type, 'Metadata::Ad')
        elsif metadata.meta_type == 'custom' and metadata.key_type == 'widget'
        	puts "Converting #{metadata.inspect} to Metadata::CustomWidget type"
        	metadata.update_attribute(:type, 'Metadata::CustomWidget')
        else
        	next
        end
      end
    end

  end

  namespace :setup do

    desc "Default N2 setup task"
    task :default do
      puts "Setting up your N2 framework"
      Rake::Task['db:setup'].invoke
      Rake::Task['n2:data:load_locale_data'].invoke
      Rake::Task['n2:data:generate_widgets'].invoke
      Rake::Task['n2:util:compass:compile_css'].invoke
      puts "Finished setting up your application"
    end

    desc "Convert an existing php based newscloud framework to N2"
    task :convert_existing => :environment do
      puts "Setting up your N2 framework from an existing newscloud installation"
      # Using system here because for some reason invoking it manually won't
      # directly print get the input request
      system('rake n2:db:convert_and_create_database')
      #Rake::Task['n2:db:convert_and_create_database'].invoke
    end

    desc "Backup an existing N2 application, rebuild the app settings and merge back in the data"
    task :backup_and_rebuild => :environment do
      dump_file = "#{RAILS_ROOT}/db/backup_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.sql"
      full_dump_file = "#{RAILS_ROOT}/db/full_backup_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.sql"
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      raise "Invalid adapter, this only works with mysql." unless config["adapter"] == 'mysql'

      ignore_tables = 'schema_migrations'

      dump = []
      dump << "mysqldump"
      dump << "--no-create-info"
      dump << "--complete-insert"
      dump << "-u #{config["username"]}"
      dump << "-p#{config["password"]}" if config["password"].present?
      ignore_tables.split(',').each do |table|
        dump << "--ignore-table=#{config["database"]}.#{table}"
      end
      dump << "#{config["database"]}"

      puts "Creating a full backup"
      Rake::Task["db:database_dump"].invoke ENV['file']=full_dump_file

      #puts "SQL::  #{dump.join ' '}"
      puts "Dumping data from #{config["database"]} database... this may take a minute"
      File.open(dump_file, "w+") do |file|
        output = `#{dump.join ' '}`
        raise "Failed on mysql error, please check the error and try again." if output.empty?
        file << output
      end
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:schema:load'].invoke
      puts "Reloading data"
      insert = []
      insert << "mysql"
      insert << "-u #{config["username"]}"
      insert << "-p#{config["password"]}" if config["password"].present?
      insert << "#{config["database"]}"
      insert << "< #{dump_file}"
      output = `#{insert.join ' '}`
      puts "Finishing rebuilding your application"

    end

  end
  desc "Alias for n2:setup:default"
  task :setup => 'setup:default'
end

def valid_url? url
  url =~ /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i
end
