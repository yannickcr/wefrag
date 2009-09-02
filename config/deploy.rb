set :application, "wefrag"

set :scm, :git
set :git_enable_submodules, true
set :repository, "git@github.com:hc/wefrag.git"

set :branch, "deploy"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

role :app, "wefrag.com"
role :web, "wefrag.com"
role :db,  "wefrag.com", :primary => true
set :deploy_to, "/home/cedric/#{application}/production"

default_run_options[:pty] = true

set :runner,   :cedric
set :user,     "cedric"
set :use_sudo, false

task :after_symlink do
  run "ln -nfs #{shared_path}/medias #{current_path}/public/medias"
  run "rm -rf #{current_path}/tmp/attachment_fu"
  run "ln -nfs #{shared_path}/tmp/attachment_fu #{current_path}/tmp/attachment_fu"
end

namespace :deploy do
  task :start, :roles => :app do
    sudo "/etc/init.d/thin start", :as => :root
  end

  task :stop, :roles => :app do
    sudo "/etc/init.d/thin stop", :as => :root
  end

  task :restart, :roles => :app do
    sudo "/etc/init.d/thin restart", :as => :root
  end
end

task :after_update_code, :roles => :app do
  desc "Link config files"
  [ 'database.yml', 'initializers/zzz_custom_config.rb' ].each do |file|
    run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
  end

  desc "Generate ultrasphinx configuration"
  run <<-CMD
    cd #{release_path} &&
    RAILS_ENV=production rake ultrasphinx:configure
  CMD

  desc "Generate styles and scripts cache"
  run <<-CMD
    cd #{release_path} &&
    RAILS_ENV=production rake tmp:assets:rebuild
  CMD
end

