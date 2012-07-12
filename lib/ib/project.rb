class IB::Project
  def write app_path = "./app", resources_path = "./resources"
    project = Xcodeproj::Project.new
    target = project.targets.new_static_library(:ios, 'ui')
    stubs = IB::Generator.new.write(app_path, "ui.xcodeproj")
    stubs_path = Pathname.new("ui.xcodeproj/stubs.h")
    files = [Xcodeproj::Project::PBXNativeTarget::SourceFileDescription.new(stubs_path, nil, nil)]
    

    Dir.glob("#{resources_path}/**/*.{xcdatamodeld,png,jpg,jpeg,storyboard,xib}") do |file|
      files << Xcodeproj::Project::PBXNativeTarget::SourceFileDescription.new(Pathname.new(file), nil, nil)
    end

    target.add_source_files(files)

    project.save_as("ui.xcodeproj")
  end
end