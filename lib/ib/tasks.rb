# -*- encoding : utf-8 -*-
require 'rake' unless defined? Rake

module IB
  class RakeTask
    include Rake::DSL

    def initialize
      require 'ib/project'
      @project = IB::Project.new
      yield @project if block_given?
      define_tasks
    end

    def define_tasks
      namespace :ib do
        desc "Generates ib.xcodeproj"
        task :project do
          @project.write
        end

        desc "Generates ib.xcodeproj and opens it in XCode"
        task :open => :project do
          system "open ib.xcodeproj"
        end
      end
      desc "Same as 'ib:open'"
      task :ib => "ib:open"
    end
  end
end
