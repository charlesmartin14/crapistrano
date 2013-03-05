require 'rubygems' 

SPEC = Gem::Specification.new do |s|
  s.name = 'deprec'
  s.version = '2.4'
  
  s.authors = ['Mike Bailey, Charles H Martin, PhD']
  s.description = <<-EOF
      This project provides libraries of Capistrano tasks and extensions to 
      remove the repetative manual work associated with installing services 
      on linux servers.

      Modified for my own personal use to work with Sinatra
  EOF
  s.email = 'charlesmartin14@gmail.com'
  s.homepage = 'https://github.com/charlesmartin14/crapistrano'
  s.summary = 'deployment recipes for capistrano , modified by chm'

  s.require_paths = ['lib']
  s.add_dependency('capistrano', '> 2.5.0')
  s.add_dependency('capistrano-ext', '>= 1.2.1')
  candidates = Dir.glob("{bin,docs,lib,rake}/**/*") 
  candidates.concat(%w(CHANGELOG COPYING LICENSE README.md THANKS))
  s.files = candidates.delete_if do |item| 
    item.include?("CVS") || item.include?("rdoc") 
  end
  s.default_executable = "depify"
  s.executables = ["depify"]
end