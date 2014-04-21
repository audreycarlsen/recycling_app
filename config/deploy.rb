# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'recycling_app'
set :repo_url, 'git@github.com:audreycarlsen/recycling_app.git'
set :use_sudo, false
set :keep_releases, 1
after "deploy:restart", "deploy:cleanup"

role :resque_worker, "ubuntu@ec2-54-187-54-26.us-west-2.compute.amazonaws.com"
role :resque_scheduler, "ubuntu@ec2-54-187-54-26.us-west-2.compute.amazonaws.com"
set :workers, { "*" => 1 }
set :resque_environment_task, true
after "deploy:restart", "resque:restart"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/recycling_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :linked_dirs, %w{tmp/pids}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
