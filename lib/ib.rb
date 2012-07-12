unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  app.files.unshift File.join(File.dirname(__FILE__), 'ib/controller_ext.rb')
end

module IB
end

require 'ib/tasks'
require 'ib/parser'
require 'ib/version'
require 'ib/generator'
require 'ib/project'