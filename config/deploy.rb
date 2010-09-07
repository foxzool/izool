default_run_options[:pty] = true
set :application, "izool"
set :repository,  "git@github.com:zhooul/izool.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "zhouliang"

ssh_options[:forward_agent] = true  
ssh_options[:port] = 7788 
set :deploy_to, "/home/zhouliang/izool"  
set :use_sudo, false  

role :web, "125.39.189.88"                          # Your HTTP server, Apache/etc
role :app, "125.39.189.88"                          # This may be the same as your `Web` server
role :db,  "125.39.189.88", :primary => true # This is where Rails migrations will run


set :branch, "master"

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :bundler do
    task :create_symlink, :roles => :app do
      shared_dir = File.join(shared_path, 'bundle')
      release_dir = File.join(current_release, '.bundle')
      run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
    end
     
    task :bundle_new_release, :roles => :app do
      bundler.create_symlink
      run "cd #{release_path} && sudo bundle install --without test"
    end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'
