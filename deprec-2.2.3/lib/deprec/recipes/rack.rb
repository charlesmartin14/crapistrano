# Copyright Charles Martin Solutions
#
# chm 3-Dec-2011

Capistrano::Configuration.instance(:must_exist).load do 
  namespace :deprec do
    namespace :rack do

      _cset :rack_env, 'production'   # not set
      _cset :packages_for_project, nil
      
      set :run_method, :sudo   # ubuntu or root?
      
      
      desc "Install Rack stack on Ubuntu server (8.04, 10.04)"
      task :install_stack do   
        
         deprec2.mkdir("#{deploy_to}", {:owner => "ubuntu", :via => :sudo} )
         deprec2.mkdir("#{deploy_to}/passenger", {:owner => "ubuntu", :via => :sudo} )
         deprec2.mkdir("#{deploy_to}/releases", {:owner => "ubuntu", :via => :sudo} )

        if scm==:subversion then
          top.deprec.svn.install   
        else
          top.deprec.git.install    
        end
        
        apt.update

        top.deprec.mri.install       
        top.deprec.rubygems.install
        top.deprec.rubygems.install_bundler
       # top.deprec.rubygems.update_system  # do I need this?
        
        # system specific gems I might need
        #gem2.install right_aws 
                
        # no longer supported: gem2.install s3sync
        # TODO:  run s3cmd  -- configure    or transfer keys there
        
        # TODO; install libyaml
        #  check for other issues
       
        gem2.install "trollop"  #
        gem2.install "whenever"  # not needed ? see deploy.rb?
        # start whenever?  when?


        # TODO:  make dir by hand and try update...was this the only problem?
        #
           # mkdir /var/www ?

        # TODO:  make this a varibale we can weset so it is not hard coded in the apache config file
        # TODO:  add NOSQL mongo and redis
        # TODO:  add xapian installer and config, loader
        #  apache_vhost_document_root   ???
        
        # currently only apache and passenger supported
        top.deprec.web.install        # Uses web_server_type .. TOOD:  29-aug-2012  did not run passenger:config
        top.deprec.app.install        # Uses app_server_type
        
        # CHM:  26-jul-2012
        # do I need syslog 
        top.deprec.logrotate.install  # apache only?
   
        #top.deprec.monit.install   
        
        # TODO: implement all and test
        # redis might log to shell...or just use switch statment
       # if top.deprec.nosql==:memcached then
       #   top.deprec.memcached.install       
       # end
       # top.deprec.nosql.install unless top.deprec.nosql==:none
        top.deprec.redis.install    

        
        # add search engines
        #  sphinx, xapaian
        #  does sphix need mysql?
        
        # do I need to install specifi rack middleware or will cap deploy do this?
   
      end
      
      desc "Generate config files for rack app."
      task :config_gen do
        top.deprec.web.config_gen_project
        top.deprec.app.config_gen_project
      end

      # 29-aug-2012 figure this out
      #  run passenger:config, and remove apache sites-enabled 000-default symlink
      desc "Push out config files for rack app."
      task :config do
        top.deprec.web.config_project
        top.deprec.app.config_project
      end

      desc "Install debs listed in :packages_for_project"
      task :install_packages, :roles => :app do
        if packages_for_project
          apt.install({ :base => packages_for_project }, :stable)
        end
      end

     
      # RESTART APACHE AND PASSENGER
      # or issue apache command to reread config file 
    end
  end
end
