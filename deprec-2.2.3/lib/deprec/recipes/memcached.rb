# #  http://techgurulive.com/2010/01/26/how-to-configure-memcached-memcached-configuration-parameters/
# 
# # 8-Aug-2012  Not Working Yet
# #  not sure if/how to specify config file
# # not hard to set up if necessary
# #
# # not sure if / need to setup client
# 
# Capistrano::Configuration.instance(:must_exist).load do
  # namespace :deprec do
    # namespace :memcache do
# 
      # set :memcached_ip, '127.0.0.1'
      # set :memcached_port, 11211
      # set :memcached_memory, 256
      # set :memcached_max_connections, 2048
# 
#       
      # set :memcached_bin, "/usr/binm/memcached"
      # set :memcached_config, "/etc/memcached.conf"
# 
# 
# 
      # # Not sure how to specify config file on command line
      # task :memcached_start do
        # run "memcached -d -m #{memcached_memory} -l #{memcached_ip} -p #{memcached_port}"
      # end
# 
      # # XXX needs thought/work
      # task :memcached_stop do
        # run "killall memcached"
      # end
# 
      # # XXX needs thought/work
      # task :memcached_restart do
        # memcached_stop
        # memcached_start
      # end
# 
      # # need client also?
      # # single server setup
      # task :install_memcached do
        # apt.install( {:base => %w(memcached)}, :stable )
      # end
    # end
#     
#     
    # # desc "Stop the memcached server"
    # # task :stop, :role => :app do
      # # pid = capture("ps -o pid,command ax | grep memcached | awk '!/awk/ && !/grep/ {print $1}'")
      # # sudo "kill -INT #{pid}" unless pid.strip.empty?
    # # end
# # 
    # # desc "Restart the memcached server"
    # # task :restart, :role => :app do
      # # pid = capture("ps -o pid,command ax | grep memcached | awk '!/awk/ && !/grep/ {print $1}'")
      # # memcached.stop unless pid.strip.empty?
      # # memcached.start
    # # end
# 
#   
      # desc "Install amd start memcached"
      # task :install do
#          
        # apt.add_source("10gen", "deb http://downloads-distro.memcached.org/repo/debian-sysvinit dist")
        # apt.key("7F0CEB10")
        # apt.install( {:base => %w(memcached-10gen)}, :stable )
# 
#         
        # # why initial_config (as in nginx) and not just config (as in apache?)
        # initial_config
        # config 
        # config_project 
        # activate
        # start
#         
      # end
    # end
#     
# 
    # SYSTEM_CONFIG_FILES[:memcached] = [
# 
    # ]
# 
# 
    # PROJECT_CONFIG_FILES[:memcached] = [
       # {:template => 'memcached.conf.erb',
        # :path => "#{memcached_config}",
        # :mode => 0644,
        # :owner => 'root:root'}  
    # ]
# 
    # task :initial_config, :roles => :web do
      # SYSTEM_CONFIG_FILES[:memcached].each do |file|
        # deprec2.render_template(:memcached, file.merge(:remote => true))
      # end
    # end
# 
    # task :config_gen do
      # SYSTEM_CONFIG_FILES[:memcached].each do |file|
        # deprec2.render_template(:memcached, file)
      # end
    # end
# 
    # desc "Generate config files for redis app."
    # task :config_gen_project do
     # PROJECT_CONFIG_FILES[:memcached].each do |file|
       # deprec2.render_template(:memcached, file)
     # end
    # end
# 
    # desc "Push redis config files to server"
    # task :config, :roles => :web do
      # deprec2.push_configs(:memcached, SYSTEM_CONFIG_FILES[:memcached])
    # end
# 
    # desc "Push out config files for rails app."
    # task :config_project, :roles => :web do
      # deprec2.push_configs(:memcached, PROJECT_CONFIG_FILES[:memcached])
    # end
#     
     # desc "Set memcached to start on boot"
      # task :activate, :roles => :web do
        # run "#{sudo} update-rc.d memcached defaults"
      # end
# 
#       
      # desc "Set memcached to not start on boot"
      # task :deactivate, :roles => :web do
        # run "#{sudo} update-rc.d -f memcached remove"
      # end
# 
  # end
# 
# 
# 
   # end
# 
# end