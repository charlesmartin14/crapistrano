#
# Assume runs on 1 port
#
# http://www.mongodb.org/display/DOCS/Quickstart+Unix
#   http://blog.dynamic50.com/2010/04/21/installing-a-monitored-mongodb-ruby-1-9-nginx-stack-with-passenger-on-ubuntu-linux/
#
#  http://docs.mongodb.org/manual/tutorial/install-mongodb-on-linux/
#  http://www.mkyong.com/mongodb/how-to-install-mongodb-on-ubuntu/
Capistrano::Configuration.instance(:must_exist).load do
  namespace :deprec do

    set :mongodb_bin_path, "/usr/bin"
    set :mongodb_config, "/etc/mongodb.conf"

    set :mongodb_db_path, "/var/lib/mongodb"
    set :mongodb_log_path, "/var/log/mongodb.log"
    set :mongodb_log_append, true
    set :mongodb_port, 27017

    namespace :mongodb do
      
      desc "Starts the mongodb server"
      task :start, :role => :app do
        sudo "#{mongodb_bin_path}/mongod --fork --config=#{mongodb_config}"
      end

      desc "Stop the mongodb server"
      task :stop, :role => :app do
        pid = capture("ps -o pid,command ax | grep mongod | awk '!/awk/ && !/grep/ {print $1}'")
        sudo "kill -INT #{pid}" unless pid.strip.empty?
      end

      desc "Restart the mongodb server"
      task :restart, :role => :app do
        pid = capture("ps -o pid,command ax | grep mongod | awk '!/awk/ && !/grep/ {print $1}'")
        mongodb.stop unless pid.strip.empty?
        mongodb.start
      end

      desc "Install amd start mongodb"
      task :install do

        apt.add_source("10gen", "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist")
        apt.key("7F0CEB10")
        apt.install( {:base => %w(mongodb-10gen)}, :stable )

        # why initial_config (as in nginx) and not just config (as in apache?)
        initial_config
        config
        config_project
        activate
        start

      end
      
    

    # ??
    SYSTEM_CONFIG_FILES[:mongodb] = [

    ]

    PROJECT_CONFIG_FILES[:mongodb] = [
      {:template => 'mongodb.conf.erb',
        :path => "#{mongodb_config}",
        :mode => 0644,
        :owner => 'root:root'}
    ]

    task :initial_config, :roles => :web do
      SYSTEM_CONFIG_FILES[:mongodb].each do |file|
        deprec2.render_template(:mongodb, file.merge(:remote => true))
      end
    end

    task :config_gen do
      SYSTEM_CONFIG_FILES[:mongodb].each do |file|
        deprec2.render_template(:mongodb, file)
      end
    end

    desc "Generate config files for redis app."
    task :config_gen_project do
      PROJECT_CONFIG_FILES[:mongodb].each do |file|
        deprec2.render_template(:mongodb, file)
      end
    end

    desc "Push redis config files to server"
    task :config, :roles => :web do
      deprec2.push_configs(:mongodb, SYSTEM_CONFIG_FILES[:mongodb])
    end

    desc "Push out config files for rails app."
    task :config_project, :roles => :web do
      deprec2.push_configs(:mongodb, PROJECT_CONFIG_FILES[:mongodb])
    end

    desc "Set MongoDB to start on boot"
    task :activate, :roles => :web do
      run "#{sudo} update-rc.d mongodb defaults"
    end

    desc "Set MongoDB to not start on boot"
    task :deactivate, :roles => :web do
      run "#{sudo} update-rc.d -f mongodb remove"
    end
    
    end

  end

end

