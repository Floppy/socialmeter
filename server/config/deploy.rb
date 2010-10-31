set :application, "socialmeter"
set :repository,  "git@github.com:Floppy/socialmeter.git"

set :scm, :git

role :web, "socialmeter.floppy.org.uk"
role :app, "socialmeter.floppy.org.uk"
role :db,  "socialmeter.floppy.org.uk", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'server','tmp','restart.txt')}"
  end
end

after "deploy:update_code", "database:copy_config", "amee:copy_config", "gems:install"

namespace :gems do
  desc "Install required gems on server"
  task :install do
    run "#{try_sudo} rake RAILS_ENV=production -f #{release_path}/Rakefile gems:install"
  end
end

namespace :database do
  desc "Make copy of database.yml on server"
  task :copy_config do
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :amee do
  desc "Make copy of amee.yml on server"
  task :copy_config do
    run "cp #{shared_path}/config/amee.yml #{release_path}/config/amee.yml"
  end
end

