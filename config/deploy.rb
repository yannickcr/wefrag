set :application, "wefrag"

set :scm, :git
set :repository, "git@github.com:hc/wefrag.git"

set :branch, "stable"
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

task :start, :roles => [:web] do
  sudo "/etc/init.d/thin start", :as => :root
end

task :stop, :roles => [:web] do
  sudo "/etc/init.d/thin stop", :as => :root
end

task :restart, :roles => [:web] do
  sudo "/etc/init.d/thin restart", :as => :root
end

task :after_update_code, :roles => [:web] do
  desc "Link in the production database.yml"
  [ 'database', 'config' ].each do |file|
    run "ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config/#{file}.yml"
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

