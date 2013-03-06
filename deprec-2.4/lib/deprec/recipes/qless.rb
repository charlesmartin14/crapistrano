#
# chm 5-Mar-2013
#
Capistrano::Configuration.instance(:must_exist).load do
  namespace :deprec do
    namespace :qless do

     #  it is good to know how to deploy from a git repo...
     # although this will be removed and replaced with a gem

     # 5-mar-113  chm   in principle this should work,..but it does not !
     
      desc "install qless"
      task :install do
      # for make test
        apt.install( {:base => %w(git)}, :stable )

       # deprec2.mkdir("/usr/local/src/qless", :via => :sudo)
       #  where does this belong ?  how can i set up
        version = '1.0s'
        set :src_package, {
          :download_method => :git,
         :file => '',
         :dir => 'qless',
         :url => "https://github.com/charlesmartin14/qless.git",
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