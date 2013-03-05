# Copyright 2006-2008 by Mike Bailey. All rights reserved.

# TODO:  replace with sudo apt-get install --force-yes ruby1.9
#  or force a specific version if desired
#
Capistrano::Configuration.instance(:must_exist).load do 

  namespace :deprec do
    namespace :mri do
            
      # includes nokogiri deps
      # add other common gem dependencies too     
      desc "Install Ruby 1.9.3 (on latest ubuntu micro instance 12.04)"
      task :install do
         apt.update
         apt.install( { :base => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline-gplv2-dev libxslt-dev libxml2-dev) }, :stable)
         apt.install( { :base => %w(ruby1.9.1-full) }, :stable)  # needs -y option?  #update still fails
      end
      
    end
  end
  
end
