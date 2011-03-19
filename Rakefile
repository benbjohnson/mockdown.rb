lib = File.expand_path('lib', File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)

require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rspec/core/rake_task'
require 'mockdown'

#############################################################################
#
# Standard tasks
#
#############################################################################

require 'rcov/rcovtask'
Rcov::RcovTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.rcov_opts = ['--exclude', 'gems\/,spec\/']
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Mockdown #{Mockdown::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :console do
  sh "irb -rubygems -r ./lib/mockdown.rb"
end


#############################################################################
#
# Ragel tasks
#
#############################################################################

task :ragel do
  ragel('parser')
end

def ragel(filename, format=false)
  dir = File.expand_path(File.dirname(__FILE__))
  sh "ragel -R #{dir}/ragel/#{filename}.rl -o #{dir}/lib/mockdown/#{filename}.rb"
  #sh "eden rewrite #{dir}/lib/mockdown/#{filename}.rb"
end

task :dot do
  dot('parser')
end

def dot(filename)
  dir = File.expand_path(File.dirname(__FILE__))
  sh "ragel -V #{dir}/ragel/#{filename}.rl | dot -Tpng -o #{dir}/ragel/dot/#{filename}.png"
end


#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release do
  puts ""
  print "Are you sure you want to relase Mockdown #{Mockdown::VERSION}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build gem and upload
  sh "gem build mockdown.gemspec"
  sh "gem push mockdown-#{Mockdown::VERSION}.gem"
  sh "rm mockdown-#{Mockdown::VERSION}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{Mockdown::VERSION}'"
  sh "git tag v#{Mockdown::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Mockdown::VERSION}"
end
