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

before "deploy:bundle_install", "deploy:install_bundler"
after "deploy:update_code", "deploy:bundle_install"

namespace :deploy do
  desc "installs Bundler if it is not already installed"
  task :install_bundler, :roles => :app do
    sudo "sh -c 'if [ -z `which bundle` ]; then echo Installing Bundler; sudo gem install bundler; fi'"
  end

  desc "run 'bundle install' to install Bundler's packaged gems for the current deploy"
  task :bundle_install, :roles => :app do
    run "cd #{release_path} && bundle install"
  end
end

