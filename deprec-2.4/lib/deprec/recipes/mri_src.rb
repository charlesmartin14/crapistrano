# Copyright 2006-2008 by Mike Bailey. All rights reserved.

# TODO:  replace with sudo apt-get install --force-yes ruby1.9
#  or force a specific version if desired
#
Capistrano::Configuration.instance(:must_exist).load do 

  namespace :deprec do
    namespace :mri do
            
#      SRC_PACKAGES['ruby-1.8.7-p330'] = {
      # SRC_PACKAGES['mri_1_8_7'] = {
        # :md5sum => "50a49edb787211598d08e756e733e42e  ruby-1.8.7-p330.tar.gz",
        # :url => "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p330.tar.gz",
        # :deps => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline5-dev),
        # :configure => "./configure --with-readline-dir=/usr/local;"
      # }

      # also include deps for nokogiri 
      SRC_PACKAGES['mri_1_9_2'] = {
        :md5sum => "0d6953820c9918820dd916e79f4bfde8  ruby-1.9.2-p180.tar.gz", 
        :url => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz",
        :deps => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline5-dev libxslt-dev libxml2-dev),
        :configure => "./configure",
        :post_install => 'sudo gem update --system'
      }

      # 1.9.3
      #  needs libyaml-dev I think
      
      
      src_package_options = SRC_PACKAGES.keys.select{|k| k.match /^mri_*/ }
      set(:mri_src_package) { 
        puts "Select mri_src_package from list:"
        Capistrano::CLI.ui.choose do |menu|
          menu.choices(*src_package_options)
        end
      }

      desc "Install Ruby"
      task :install do
        puts "mri_src_package is #{mri_src_package}"
        deprec2.download_src(SRC_PACKAGES[mri_src_package])
        deprec2.install_from_src(SRC_PACKAGES[mri_src_package])
      end
      
    end
  end
  
end
