namespace :n2 do
  namespace :db do
    desc "Convert existing newscloud database to new format"
    task :convert_database do
      puts "This will convert an existing newscloud database to the new rails format"
      dump_file = "db/conversion_dump.sql"
      db_name = get_input "Database Name: "
      db_user = get_input "Database User: "
      db_password = get_input "Database Password (leave blank for no password or use '-p' to prompt for password): "

      ignore_tables = 'AdCode,AdShare,AdTrack,Admin_DataStore,Admin_User,Challenges,ChallengesCompleted,ContactEmails,FeaturedTemplate,FeaturedWidgets,FeedMedia,FolderLinks,Folders,ForumTopics,Log,LogDumps,LogExtra,MicroAccounts,MicroPosts,NotificationMessages,Notifications,Orders,OutboundMessages,Photos,Prizes,RawExtLinks,RawSessions,SessionLengths,Sites,Subscriptions,SurveyMonkeys,SystemStatus,TaggedObjects,Templates,UserBlogs,UserCollectives,UserInvites,Videos,WeeklyScores,cronJobs,feedType'

      dump = []
      dump << "mysqldump"
      dump << "--opt"
      dump << "-u #{db_user}"
      dump << "-p#{db_password}" unless db_password.empty? or db_password == '-p'
      dump << "-p" if db_password == '-p'
      ignore_tables.split(',').each do |table|
        dump << "--ignore-table=#{db_name}.#{table}"
      end
      dump << "#{db_name}"

      #puts "SQL::  #{dump.join ' '}"
      puts "Dumping data from #{db_name} database... this may take a minute"
      File.open(dump_file, "w+") do |file|
        output = `#{dump.join ' '}`
        raise "Failed on mysql error, please check the error and try again." if output.empty?
        file << output
      end
      puts "Finished dumping data"
      puts "Converting to new database format"
    end

    desc "Create database from existing sql dump"
    task :create_from_dump do
      dump_file = ENV["file"] || "db/conversion_dump.sql"

      Rake::Task['db:reset_app'].invoke ENV['file'] = dump_file
    end

    desc "Convert an existing nescloud database and create a new rails database"
    task :convert_and_create_database => [:convert_database, :create_from_dump] do
      puts "Finished converting your old database into the new rails format!"
      puts "Processing existing records and removing floating data"
      Rake::Task['n2:data:bootstrap'].invoke
      Rake::Task['n2:util:compass:compile_css'].invoke
      puts "All tasks finished, your new database is setup and good to go!"
    end

  end
end

def get_input prompt
  print prompt
  STDIN.gets.chomp
end
