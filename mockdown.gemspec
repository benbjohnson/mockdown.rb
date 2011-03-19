# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mockdown/version'

Gem::Specification.new do |s|
  s.name        = 'mockdown'
  s.version     = Mockdown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ben Johnson']
  s.email       = ['benbjohnson@yahoo.com']
  s.homepage    = 'http://github.com/benbjohnson/mockdown'
  s.summary     = 'Mockups for hackers'
  s.executables = ['mkdn']
  s.default_executable = 'mkdn'

  s.add_dependency('commander', '~> 4.0.3')
  s.add_dependency('ffi-ncurses', '~> 0.3.3')

  s.add_development_dependency('rake', '~> 0.8.7')
  s.add_development_dependency('rspec', '~> 2.4.0')
  s.add_development_dependency('mocha', '~> 0.9.12')
  s.add_development_dependency('unindentable', '~> 0.1.0')
  s.add_development_dependency('rcov', '~> 0.9.9')
  s.add_development_dependency('eden', '~> 0.1.1')

  s.test_files   = Dir.glob('test/**/*')
  s.files        = Dir.glob('lib/**/*') + %w(README.md)
  s.require_path = 'lib'
end
