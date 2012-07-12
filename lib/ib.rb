if defined?(Motion::Project::Config)
  Motion::Project::App.setup do |app|
    app.files.unshift File.join(File.dirname(__FILE__), 'ib/outlets.rb')
  end
end

module IB
end

require 'fileutils'
require 'xcodeproj'

require 'ib/tasks'
require 'ib/parser'
require 'ib/version'
require 'ib/generator'
require 'ib/project'