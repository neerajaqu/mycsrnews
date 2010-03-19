namespace :n2 do
  namespace :data do

    desc "Bootstrap and convert existing data"
    task :bootstrap => [:environment, :pre_register_users, :delete_floating_content, :delete_floating_comments, :delete_floating_ideas, :delete_floating_questions_and_answers, :generate_model_slugs, :generate_widgets, :load_seed_data, :convert_images_to_paperclip] do
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
        content.destroy and count += 1 unless content.user.present?
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

  end
end
