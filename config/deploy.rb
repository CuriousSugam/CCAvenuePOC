# config valid only for current version of Capistrano
lock "3.7.1"

set :initial, ENV['initial'] || 'false'

#rvm version in server
set :rvm_ruby_version, 'ruby-2.2.0'

#Application name
set :application, 'ccavenues_poc'

# Default value for :scm is :git
set :scm, :git

#Github url for the repo
set :repo_url, 'git@github.com:CuriousSugam/POC.git'

#Server user
set :user, "deploy"

set :deploy_to, "/home/projects/dev/ccavenues_poc"

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')


namespace :deploy do
  desc "Upload database.yml and application.yml files."
  task :yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read("config/application.yml")), "#{shared_path}/config/application.yml"
    end
  end
end




# set :application, "Cc_avenues_POC"
# set :repo_url, "git@example.com:me/my_repo.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
