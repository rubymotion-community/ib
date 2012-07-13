class IB::Project
  def write app_path = "app", resources_path = "resources", pods_headers_path = "vendor/Pods/Headers"
    project = Xcodeproj::Project.new
    target = project.targets.new_static_library(:ios, 'ui')

    resources = project.groups.new('path' => resources_path, 'name' => 'Resources')
    support   = project.groups.new('name' => 'Supporting Files')
    pods      = project.groups.new('name' => 'Pods')

    stubs_path = "ui.xcodeproj/stubs.h"
    IB::Generator.new.write(app_path, "ui.xcodeproj")
    support.files.new 'path' => stubs_path

    resource_exts = %W{xcdatamodeld png jpg jpeg storyboard xib lproj}
    Dir.glob("#{resources_path}/**/*.{#{resource_exts.join(",")}}") do |file|
      file = file.gsub(/^#{resources_path}\//, '')
      if file.end_with? ".xcdatamodeld"
        obj = resources.groups.new('isa' => 'XCVersionGroup', 'path' => file, 'sourceTree' => '<group>', 'versionGroupType' => 'wrapper.xcdatamodel')
        file = obj.files.new('path' => file.gsub(/xcdatamodeld$/, 'xcdatamodel'), 'sourceTree' => '<group>', 'lastKnownFileType' => 'wrapper.xcdatamodel')
        obj.attributes['currentVersion'] = file.uuid
      else
        resources.files.new('path' => file, 'sourceTree' => '<group>')
      end
    end

    Dir.glob("#{pods_headers_path}/**/*.h") do |file|
      pods.files.new('path' => file)
    end

    # Add Basic System Frameworks
    # frameworks = ["UIKit", "QuartzCore", "CoreGraphics", "CoreData"]
    # doesn't work with UIKit

    frameworks = ["QuartzCore", "CoreGraphics", "CoreData"]
    frameworks.each do |framework|
      file = project.add_system_framework framework
      target.frameworks_build_phases.first << file
    end


    project.save_as("ui.xcodeproj")
  end
end