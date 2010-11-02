set :application, "socialmeter"
set :repository,  "git@github.com:Floppy/socialmeter.git"

set :deploy_to, "/var/www/socialmeter.floppy.org.uk"

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

after 'deploy:finalize_update', 'shared:relink'
after "deploy:update_code", "config:copy", "gems:install"

namespace :gems do
  desc "Install required gems on server"
  task :install do
    run "#{try_sudo} rake RAILS_ENV=production -f #{release_path}/server/Rakefile gems:install"
  end
end

namespace :config do
  desc "Copy config files on server"
  task :copy do
    run "cp #{shared_path}/config/database.yml #{release_path}/server/config/database.yml"
    run "cp #{shared_path}/config/amee.yml #{release_path}/server/config/amee.yml"
    run "cp #{shared_path}/config/config.php #{release_path}/data_collection/config.php"
  end
end

namespace :shared do
  task :relink do
    run <<-CMD
      rm -rf #{latest_release}/server/log #{latest_release}/server/public/system #{latest_release}/server/tmp/pids &&
      mkdir -p #{latest_release}/server/public &&
      mkdir -p #{latest_release}/server/tmp &&
      ln -s #{shared_path}/log #{latest_release}/server/log &&
      ln -s #{shared_path}/system #{latest_release}/server/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/server/tmp/pids
    CMD
  end
end