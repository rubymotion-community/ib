#!/usr/bin/env rake
require "bundler/gem_tasks"

# Travis support
# cite from https://github.com/CocoaPods/Xcodeproj/blob/master/Rakefile
def on_rvm?
  `which ruby`.strip.include?('.rvm')
end

def rvm_ruby_dir
  @rvm_ruby_dir ||= File.expand_path('../..', `which ruby`.strip)
end

desc 'Install dependencies'
task :bootstrap, :use_bundle_dir? do |t, args|
  options = []
  options << "--without=documentation"
  options << "--path ./travis_bundle_dir" if args[:use_bundle_dir?]
  sh "bundle install #{options * ' '}"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rspec_opts = ['-cfs']
  end
rescue LoadError => e
end
