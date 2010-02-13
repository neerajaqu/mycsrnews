namespace :n2 do
  namespace :data do

    desc "Bootstrap and convert existing data"
    task :bootstrap => [:environment, :pre_register_users, :delete_floating_content, :delete_floating_ideas, :generate_model_slugs, :generate_widgets, :load_seed_data] do
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
        user.user_info.destroy if user.user_info.present?
        user.destroy
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

    desc "Delete Floating Content Posts"
    task :delete_floating_content => :environment do
      puts "Deleting floating contents"
      count = 0
      Content.all.each do |content|
        content.destroy and count += 1 unless content.user.present?
      end
      puts "Deleted #{count} floating contents"
    end

    desc "Generate model slugs"
    task :generate_model_slugs => :environment do
      ['User', 'Content', 'IdeaBoard'].each do |model_name|
        puts "Creating slugs for #{model_name.titleize}"
        Rake::Task['friendly_id:redo_slugs'].invoke ENV['MODEL']=model_name

        # Reenable friendly id tasks so they can be run in the next iteration
        Rake::Task['friendly_id:redo_slugs'].reenable
        Rake::Task['friendly_id:make_slugs'].reenable
        Rake::Task['friendly_id:remove_old_slugs'].reenable
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

  end
end
