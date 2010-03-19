namespace :n2 do
  namespace :deploy do
    desc "This task runs commands after a capistrano deploy"
    task :after do
      Rake::Task['n2:util:compass:compile_css'].invoke
      Rake::Task['n2:widgets:update'].invoke
    end
  end

  namespace :util do
    namespace :compass do

      desc "Compile Compass css for specific application"
      task :compile_css do
        puts "Compiling Compass css"
        system("`which compass` --force")
      end
    end

  end
end
