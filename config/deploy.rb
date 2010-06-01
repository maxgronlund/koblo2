set :application, "koblo2"

server "188.40.142.76", :app, :web, :db, :primary => true
set :deploy_to, "/var/www/#{application}"

set :scm, :git
set :repository, "git@github.com:joerichsen/#{application}.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :copy_strategy, :checkout
set :keep_releases, 3
set :use_sudo, false
set :user, "deploy"
set :copy_compression, :bz2
set :copy_exclude, [".git/*"] 

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

# ASSETS
namespace :assets do
  task :symlink, :roles => :app do
    run <<-CMD
    ln -s #{shared_path}/config/database.yml #{release_path}/config
    CMD
  end
end

after "deploy:update_code", "assets:symlink"
