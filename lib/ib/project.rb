class IB::Project
  attr_accessor :platform, :app_path, :resources_path, :pods_headers_path

  def initialize options={}
    @platform          = options[:platform] || detect_platform || :ios
    @app_path          = options[:app_path] || "app"
    @resources_path    = options[:resources_path] || "resources"
    @pods_headers_path = options[:pods_headers_path] || "vendor/Pods/Headers"
  end

  def detect_platform
    # TODO: find a better way to detect platform
    if defined?(Motion::Project::Config)
      if Motion::Project::App.config.respond_to?(:platforms)
        Motion::Project::App.config.platforms[0] == 'MacOSX' ? :osx : :ios
      end
    end
  end

  def write
    project = Xcodeproj::Project.new
    target = project.new_target(:static_library, 'ib', platform)

    resources = project.new_group("Resources")
    resources.path = resources_path

    support   = project.new_group("Supporting Files")
    support.path = "ib.xcodeproj"

    pods      = project.new_group("Pods")
    pods.path = pods_headers_path

    IB::Generator.new.write(Motion::Project::App.config.files, "ib.xcodeproj")

    support.new_file "ib.xcodeproj/Stubs.h"
    file = support.new_file "ib.xcodeproj/Stubs.m"
    target.add_file_references([ file ])

    resource_exts = %W{xcdatamodeld png jpg jpeg storyboard xib lproj}
    Dir.glob("#{resources_path}/**/*.{#{resource_exts.join(",")}}") do |file|
      if file.end_with? ".xcdatamodeld"
        relative_file_path = file.split("/").last
        obj = resources.new_xcdatamodel_group(relative_file_path)
        internal_file = obj.files.first
        internal_file.path = relative_file_path.gsub(/xcdatamodeld$/, 'xcdatamodel')
        internal_file.source_tree = "<group>"
        resources.children << obj
      else
        resources.new_file(file)
      end
    end

    Dir.glob("#{pods_headers_path}/**/*.h") do |file|
      pods.new_file(file)
    end

    %W{QuartzCore CoreGraphics CoreData}.each do |framework|
      project.add_system_framework framework, target
    end

    project.save_as("ib.xcodeproj")
  end
end