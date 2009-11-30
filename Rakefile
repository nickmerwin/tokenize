require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/tokenize'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'tokenize' do
  self.developer 'Nick Merwin', 'nick@lemurheavy.com'
  self.rubyforge_name       = self.name # TODO this is default value
  self.spec_extras[:rdoc_options] = ""
  self.spec_extras[:homepage] = %q{http://github.com/yickster/tokenize}  
  self.extra_deps         = [['activerecord']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
