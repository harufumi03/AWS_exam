# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "cdp_web_web_aws_deploy_task"
set :repo_url, "https://github.com/harufumi03/AWS_exam.git"
set :bundle_without, %w{test}.join(':')
set :rbenv_version, '3.0.1'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}   
set :keep_releases, 5   
set :linked_files, %w{config/secrets.yml}
set :log_level, :info 

after 'deploy:published', 'deploy:seed'   # 9
after 'deploy:finished', 'deploy:restart'   # 10

namespace :deploy do
  desc 'Run seed'
  task :seed do
    on roles(:db) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
end