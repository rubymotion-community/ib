class IB::Project
  def write app_path = "app", resources_path = "resources", pods_headers_path = "vendor/Pods/Headers"
    project = Xcodeproj::Project.new
    target = project.new_target(:static_library, 'ib', :ios)

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