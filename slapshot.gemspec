# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','slapshot','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'slapshot'
  s.version = Slapshot::VERSION
  s.author = 'Mik Lernout'
  s.email = 'Mik_Lernout@Dell.com'
  s.homepage = 'http://appshot.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command line interface to the Appshot API'
  s.description = <<-EOS
This is a command line interface to the Appshot API. I allows you to search your Appshot instance, upload code and import/export informations.
EOS

# Add your other files here if you make them
  s.files = %w(
bin/slapshot
lib/slapshot/version.rb
lib/slapshot.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','slapshot.rdoc']
  s.rdoc_options << '--title' << 'slapshot' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'slapshot'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.4.0')
  
  s.add_runtime_dependency('rest-client','1.6.7')  
  s.add_runtime_dependency('json','1.7.5')  
  s.add_runtime_dependency('formatador','0.2.3')  
  s.add_runtime_dependency('spreadsheet', '0.7.4')  
end
