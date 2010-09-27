require 'bundler/capistrano'

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
    # run "cd #{current_path} && rake queue:restart_workers RAILS_ENV=production"
  end
end

# ASSETS
namespace :assets do
  task :symlink, :roles => :app do
    run <<-CMD
    ln -s #{shared_path}/config/database.yml #{release_path}/config
    ln -s #{shared_path}/config/adyen.yml #{release_path}/config
    CMD
  end
end

after "deploy:update_code", "assets:symlink"

#require 'config/boot'
#require 'hoptoad_notifier/capistrano'

# Thinking Sphinx
set :rails_env, 'production'

namespace :ts do
  task :conf, :roles => [:app] do
    run "cd #{release_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :in, :roles => [:app] do
    run "cd #{release_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{release_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{release_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
  task :rebuild, :roles => [:app] do
    run "cd #{release_path}; rake thinking_sphinx:rebuild RAILS_ENV=#{rails_env}"
  end
end

# http://github.com/jamis/capistrano/blob/master/lib/capistrano/recipes/deploy.rb
# :default -> update, restart
# :update  -> update_code, symlink
namespace :deploy do
  task :before_update_code do
    # Stop Thinking Sphinx before the update so it finds its configuration file.
    ts.stop
  end

  task :after_update_code do
    symlink_sphinx_indexes
    ts.conf
    ts.start
    ts.rebuild
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end
end

