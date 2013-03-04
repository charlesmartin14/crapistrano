# Copyright 2006-2008 by Mike Bailey. All rights reserved.
#
# chm 3-Dec-2011  
Capistrano::Configuration.instance(:must_exist).load do 
  namespace :deprec do 
    namespace :svn do
  
      desc "Install Subversion"
      task :install do
         apt.install( {:base => %w(subversion)}, :stable )
      end
    end  
  end
end
