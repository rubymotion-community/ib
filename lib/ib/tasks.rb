# -*- encoding : utf-8 -*-
require 'rake' unless defined? Rake

module IB
  class RakeTask
    class << self
      attr_writer :created
      def created?
        @@created ||= false
      end
    end
    include Rake::DSL

    def initialize
      require 'ib/project'
      @@created = true

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
      end
    end
  end
end


namespace :ib do
  desc "Generates ib.xcodeproj and opens it in XCode"
  task :open do
    if ! IB::RakeTask.created?
      # create a default instance of IB::RakeTask
      IB::RakeTask.new
    end
    Rake::Task['ib:project'].invoke
    system "open ib.xcodeproj"
  end

  # if this task is invoked
  task :project do
    if ! IB::RakeTask.created?
      puts "You haven't created an instance of IB::RakeTask in your Rakefile"
      puts
      puts "Add this somewhere in your Rakefile:"
      puts
      puts "    IB::RakeTask.new do |project|"
      puts "      # you can customize the IB::Project here"
      puts "    end"
    end
  end
end

desc "Same as 'ib:open'"
task :ib => 'ib:open'
