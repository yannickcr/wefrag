default_run_options[:pty] = true

set :runner,   :cedric
set :user,     'cedric'
set :use_sudo, false

role :app, "wefrag.com"
role :web, "wefrag.com"
role :db,  "wefrag.com", :primary => true

set :application, "wefrag"


task :after_symlink do
  run "ln -nfs #{shared_path}/medias #{current_path}/public/medias"
  run "rm -rf #{current_path}/tmp/attachment_fu"
  run "ln -nfs #{shared_path}/tmp/attachment_fu #{current_path}/tmp/attachment_fu"
end

set :stages, %w(production)
require 'capistrano/ext/multistage'

deploy.task :after_update_code, :roles => [:web] do
  desc "Link in the production database.yml"
  [ 'database', 'config' ].each do |file|
    run "ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config/#{file}.yml"
  end

  desc "Generate ultrasphinx configuration"
  run <<-CMD
    cd #{release_path} &&
    RAILS_ENV=#{stage} rake ultrasphinx:configure
  CMD

  desc "Generate styles and scripts cache"
  run <<-CMD
    cd #{release_path} &&
    RAILS_ENV=#{stage} rake tmp:assets:rebuild
  CMD
end

