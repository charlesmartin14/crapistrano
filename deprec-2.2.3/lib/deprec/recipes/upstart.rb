#
# chm 1-Aug-2012
#  http://upstart.ubuntu.com/
# NO WHERE NEAR READY YET
Capistrano::Configuration.instance(:must_exist).load do
  namespace :deprec do
    namespace :upstart do

      set :redis_ip, '127.0.0.1'  # not set
      set :redis_port, 6379
      # set :redis_maxmemory, 256   # not set

      # there are lots of other options not used yet or reset
      # these are used because they were in the quickstart guide:
      #  http://redis.io/topics/quickstart

      set :redis_pidfile, "/var/run/redis_#{redis_port}.pid"
      set :redis_daemonize, "yes"
      set :redis_dir, "/var/redis/#{redis_port}"
      set :redis_loglevel, "verbose"

      # task :start do
      # run "redis-server -d -m #{redis_memory} -l #{redis_ip} -p #{redis_port}"
      # end
      #

      # TODO:  fix, does not work?!  have to log in as ubuntu and run?!
      #  maybe I need to activate it?
      desc "Start the Redis server (as daemon)"
      task :start do
        run "redis-server /etc/redis/#{redis_port}.conf "
      end

      # desc "Stop the Redis server ?"
      # task :stop_server do
        # run 'echo "SHUTDOWN" | nc localhost 6379'
      # end

      desc "stop redis"
      task :stop do
        run "redis-cli shutdown"
      end

      desc "restart redis"
      task :restart do
        stop
        start
      end

      # is this run as sudo, ubuntu, or redix user?
      # see: http://redis.io/topics/quickstart
      desc "Install amd start redis"
      task :install do
      # for make test
        apt.install( {:base => %w(tcl8.5)}, :stable )

        deprec2.mkdir("/var/redis", :via => :sudo)
        deprec2.mkdir("/etc/redis", :via => :sudo)
        deprec2.mkdir("/etc/redis/#{redis_port}", :via => :sudo)

        version = '1.5'
        set :src_package, {
        :file => 'upstart-' + version + '.tar.gz',
        :dir => 'upstart-' +version,
        :url => "http://upstart.ubuntu.com/download/#{verson}/upstart-#{version}.tar.gz",
        :md5sum => "ef273152151c3f905d284cbdbbdb234cz",   
        :unpack => "tar zxf upstart-#{version}.tar.gz;",
        :make => 'make;',
        :configure => '',  # default is ./configure, not skip
        :post_install =>  # install, not cp, but it is break god damn it
        "sudo cp ./src/redis-benchmark /usr/bin/;
        sudo cp ./src/redis-cli /usr/bin/;
        sudo cp ./src/redis-server /usr/bin/"
        }

        # install utils/redis_init_script /etc/init.d/redis_#{redis_port}; "   }

        deprec2.download_src(src_package, src_dir)
        deprec2.install_from_src(src_package, src_dir)

        # why initial_config (as in nginx) and not just config (as in apache?)
        initial_config
        # 
        config 
        config_project 
        activate  # does this work
        start  # this does NOT work?

      end
    end

    # what does this do ?  Do I need it?
    # can I / should I do this instead of post_install
    # how do I install this and those?
    SYSTEM_CONFIG_FILES[:redis] = [

      {:template => 'redis_init_script',
        :path => "/etc/init.d/redis_#{redis_port}",
        :mode => 0755,  # correct?
        :owner => 'root:root'},

      {:template => 'redis.conf.erb',
        :path => "/etc/redis/#{redis_port}.conf",   #  not /usr/local/redis?
        :mode => 0644,
        :owner => 'root:root'}
    ]

    # Hope this works...not tested yet...taken from sphinx
    # https://github.com/dambalah/redis-stuff/blob/master/monit_config
    PROJECT_CONFIG_FILES[:redis] = [

      {:template => 'monit.conf.erb',
        :path => 'monit.conf',
        :mode => 0644,
        :owner => 'root:root'}
    ]

    task :initial_config, :roles => :web do
      SYSTEM_CONFIG_FILES[:redis].each do |file|
        deprec2.render_template(:redis, file.merge(:remote => true))
      end
    end

    task :config_gen do
      SYSTEM_CONFIG_FILES[:redis].each do |file|
        deprec2.render_template(:redis, file)
      end
    end

    desc "Generate config files for redis app."
    task :config_gen_project do
      PROJECT_CONFIG_FILES[:redis].each do |file|
        deprec2.render_template(:redis, file)
      end
    end

    desc "Push redis config files to server"
    task :config, :roles => :web do
      deprec2.push_configs(:redis, SYSTEM_CONFIG_FILES[:redis])
    end

    desc "Push out config files for rails app."
    task :config_project, :roles => :web do
      deprec2.push_configs(:redis, PROJECT_CONFIG_FILES[:redis])
    end

    desc "Set Redis to start on boot"
    task :activate, :roles => :web do
      run "#{sudo} update-rc.d redis_#{redis_port} defaults"
    end

    desc "Set Redis to not start on boot"
    task :deactivate, :roles => :web do
      run "#{sudo} update-rc.d -f redis_#{redis_port} remove"
    end

  end

end