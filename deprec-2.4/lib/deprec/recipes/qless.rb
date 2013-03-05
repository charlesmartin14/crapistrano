#
# chm 5-Mar-2013
#
Capistrano::Configuration.instance(:must_exist).load do
  namespace :deprec do
    namespace :qless do

     

      desc "install qless"
      task :install do
      # for make test
        apt.install( {:base => %w(git)}, :stable )

        deprec2.mkdir("git", :via => :sudo)

        version = 'redis-2.6.10'
        set :src_package, {
          :download_method => 'git',
         :git => '',
         :file => 'qless',
         :dir => '1.0',
         :url => "https://github.com/charlesmartin14",
         :unpack => "",
         :make => '',
         :configure => '',  # default is ./configure, not skip
         :post_install =>  ''  
        }

        deprec2.download_src(src_package, src_dir)
        deprec2.install_from_src(src_package, src_dir)
        
       # start  
      end
    


    SYSTEM_CONFIG_FILES[:qless] = [ ]

   
    PROJECT_CONFIG_FILES[:qless] = [ ]

   
    # desc "Set qless web server (why doesn't this just activate with sinatra / rack ?)"
    # task :activate, :roles => :web do
      # run "#{sudo} update-rc.d redis_#{redis_port} defaults"
    # end
# 
    # desc "Set Redis to not start on boot"
    # task :deactivate, :roles => :web do
      # run "#{sudo} update-rc.d -f redis_#{redis_port} remove"
    # end
#     
    # desc "Check that Redis is installed, running, and working"
    # task :check, :roles => :web do
      # run "ps -fe | grep redis"
    # end
# 
      # desc "Start the Redis server (as daemon)"
      # task :start, :roles => :web do
       # sudo "/etc/init.d/redis_#{redis_port} start 2>&1"
      # end
# 
      # desc "stop redis"
      # task :stop, :roles => :web do
        # sudo "redis-cli shutdown"
      # end
# 
      # desc "restart redis"
      # task :restart, :roles => :web do
        # stop
        # start
      # end


   end
  end

end