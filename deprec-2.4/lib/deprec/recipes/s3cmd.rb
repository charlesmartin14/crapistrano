#
# http://www.linuxhelp.in/2012/04/installing-s3cmd-in-ubuntu.html
#
# 8-aug-2012  TODO
#  auto set up bucket and permissions 
#  run s3cmd config, and get permissions for bucket
#  check that s3cmd can read from/write to bucket 
Capistrano::Configuration.instance(:must_exist).load do
  namespace :deprec do

    namespace :s3cmd do

      desc "Install s3cmd"
      task :install do

        apt.key_from_url("http://s3tools.org/repo/deb-all/stable/s3tools.key")
        apt.add_source_from_url("s3tools", "http://s3tools.org/repo/deb-all/stable/s3tools.list")
        apt.install( {:base => %w(s3cmd)}, :stable )

      end
    end

  end

end


#TODO:  run erb con s3cgf
#  read client specific keys from command line
#  place s3cfg.erb template in /home/ubuntu/.s3cfg
# 
#  create default bucket for the app, name must be unique
#  test:  try to upload something, see if it is actually there
# 

# TOUSE Backup
#  need ~/Backup/config.rb
#  need ~/Backup/log
#  sudo gem fog
