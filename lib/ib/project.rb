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

  def app_files
    Motion::Project::App.config.files.select do |file|
      file =~ /^(\.\/)?app\//
    end
  end

  def write
    ib_project = "ib.xcodeproj"
    project = Xcodeproj::Project.new(ib_project)
    target = project.new_target(:static_library, 'ib', platform)

    resources = project.new_group("Resources")
    resources.path = resources_path

    support   = project.new_group("Supporting Files")
    support.path = ib_project

    pods      = project.new_group("Pods")
    pods.path = pods_headers_path

    generator = IB::Generator.new(detect_platform)
    generator.write(app_files, ib_project)

    support.new_file "ib.xcodeproj/Stubs.h"
    file = support.new_file "ib.xcodeproj/Stubs.m"
    target.add_file_references([ file ])

    resource_exts = %W{xcdatamodeld png jpg jpeg storyboard xib lproj}
    Dir.glob("#{resources_path}/**/*.{#{resource_exts.join(",")}}") do |file|
      resources.new_reference(file)
    end

    Dir.glob("#{pods_headers_path}/**/*.h") do |file|
      pods.new_reference(file)
    end

    %W{QuartzCore CoreGraphics CoreData}.each do |framework|
      target.add_system_framework framework
    end

    project.save(ib_project)
  end
end
