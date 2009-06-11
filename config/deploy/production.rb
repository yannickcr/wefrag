set :deploy_to,   "/home/cedric/wefrag/production"
set :branch,      "master"

set :scm, :git
set :deploy_via, :copy
set :copy_strategy, :export

set :repository, "git@wefrag.com:wefrag.git"

deploy.task :start, :roles => [:web] do
  sudo "/etc/init.d/thin start", :as => :root
end

deploy.task :stop, :roles => [:web] do
  sudo "/etc/init.d/thin stop", :as => :root
end

deploy.task :restart, :roles => [:web] do
  sudo "/etc/init.d/thin restart", :as => :root
end

