# Copyright 2006-2008 by Mike Bailey. All rights reserved.
#
# Single Node--not distributed yet
#
#
Capistrano::Configuration.instance(:must_exist).load do 
  namespace :deprec do 
    namespace :xapian do
      
      VERSION = "1.2.12"
      
      # too many chances for bugs...what are the real defaults
      SRC_PACKAGES[:xapian_core] = {
        :filename => "xapian-core-#{VERSION}.tar.gz",   
        :dir => "xapian-core-#{VERSION}",  
        :url => "http://oligarchy.co.uk/xapian/#{VERSION}/xapian-core-#{VERSION}.tar.gz",
        :unpack => "tar zxf xapian-core-#{VERSION}.tar.gz",  # should be filename!
        :make => 'make', 
        :configure => './configure', 
        :install => 'make install;'
      }
      
           
     SRC_PACKAGES[:xapian_bindings] = {
        :filename => "xapian-bindings-#{VERSION}.tar.gz",   
        :dir => "xapian-bindings-#{VERSION}",  
        :url => "http://oligarchy.co.uk/xapian/#{VERSION}/xapian-bindings-#{VERSION}.tar.gz",
        :unpack => "tar zxf xapian-bindings-#{VERSION}.tar.gz", # should be filename! 
        :make => 'make', 
        :configure => './configure', 
        :install => 'make install;'
      }
      
      desc "install Xapian Search Engine"
      task :install_core do 
        deprec2.download_src(SRC_PACKAGES[:xapian_core], src_dir)
        deprec2.install_from_src(SRC_PACKAGES[:xapian_core], src_dir)
      end
      
      desc "install Xapian Search Engine Language Bindings"
      task :install_bindings do
        deprec2.download_src(SRC_PACKAGES[:xapian_bindings], src_dir)
        deprec2.install_from_src(SRC_PACKAGES[:xapian_bindings], src_dir)
      end
      
      desc "install Xapian Search Engine and Language Bindings"
      task :install do
        install_core
        install_bindings
      end
    
      # install dependencies for xapian
      task :install_deps do
        # apt.install( {:base => %w(blah)}, :stable )
      end

      SYSTEM_CONFIG_FILES[:xapian] = []
      PROJECT_CONFIG_FILES[:xapian] = []
      
      desc "Generate xapian config ... nothing to do here yet"
      task :config_gen do
        PROJECT_CONFIG_FILES[:xapian].each do |file|
          deprec2.render_template(:xapian, file)
        end
      end

      desc "Push xapian-core config files to server"
      task :config, :roles => :xapian do
        config_project
      end
      
      desc "Push xapian-core config files to server"
      task :config_project, :roles => :xapian do
        deprec2.push_configs(:xapian, PROJECT_CONFIG_FILES[:xapian])
      end

      # TODO need a Xapian Loader Recipe
      # desc "Restart the sphinx searchd daemon"
      # task :restart, :roles => :app do
        # run("cd #{deploy_to}/current; /usr/bin/rake us:start")  ### start or restart?  SUDO ? ###
      # end
# 
      # desc "Regenerate / Rotate the search index."
      # task :reindex, :roles => :app do
        # run("cd #{deploy_to}/current; /usr/bin/rake us:in")  ### SUDO ? ###
      # end
  
    end 
  end
end

