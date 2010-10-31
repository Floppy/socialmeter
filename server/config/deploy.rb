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

after "deploy:update_code", "gems:install"

namespace :gems do
  desc "Install required gems on server"
  task :install do
    run "#{try_sudo} rake RAILS_ENV=production -f #{release_path}/Rakefile gems:install"
  end
end