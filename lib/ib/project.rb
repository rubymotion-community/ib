# -*- encoding : utf-8 -*-
class IB::Project
  attr_accessor :platform
  attr_accessor :project_path
  attr_accessor :app_files
  attr_accessor :resource_directories

  IB_PROJECT_NAME     = 'ib.xcodeproj'
  DEFAULT_FRAMEWORKS  = %W{QuartzCore CoreGraphics CoreData}
  RESOURCE_EXTENSIONS = %W{
    xcdatamodeld png jpg jpeg storyboard xib lproj ttf otf
  }

  def initialize(options={})
    @platform     = options[:platform]
    @project_path = options[:project_path] || Dir.pwd
  end

  def motion_config
    Motion::Project::App.config
  end
  private :motion_config

  def platform
    @platform ||= motion_config.deploy_platform == 'MacOSX' ? :osx : :ios
  end

  def app_files
    @app_files ||= motion_config.files.select do |file|
      file =~ /^(\.\/)?app\//
    end
  end

  def resource_directories
    @resource_directories ||= motion_config.resources_dirs
  end

  # Writes a new ib.xcodeproj to the provided `#project_path`.
  # The following steps will occur
  #
  # * `setup_paths` - This step sets up the paths to your project's 'resources',
  #   'pods' and 'supporting files'.
  # * `generate_stub_files` - generates stub files and adds it to the build
  # * `add_resources` - Adds all resources from your RubyMotion project
  # * `add_pods` - Adds pods (if any) to ib.xcodeproj
  # * `add_frameworks` - Adds standard frameworks to your project
  # * project will then be saved
  def write
    setup_paths

    generate_stub_files
    add_resources
    add_pods
    add_frameworks

    project.save
  end

  def project
    @project ||= Xcodeproj::Project.new(ib_project_path)
  end

  def target
    @target ||= project.new_target(:static_library, 'ib', platform)
  end

  def generator
    @generator ||= IB::Generator.new(platform)
  end

  def resources
    @resources ||= project.new_group("Resources")
  end

  def support_files
    @support_files ||= project.new_group("Supporting Files")
  end

  def pods
    @pods ||= project.new_group("Pods")
  end

  def setup_paths
    support_files.path = File.join(project_path, IB_PROJECT_NAME)
    pods.path          = File.join(project_path, 'vendor/Pods/Headers')
  end

  def generate_stub_files
    generator.write(app_files, ib_project_path)

           support_files.new_file File.join(ib_project_path, 'Stubs.h')
    file = support_files.new_file File.join(ib_project_path, 'Stubs.m')
    target.add_file_references([ file ])
  end

  def add_resources
    resource_directories.each do |dir|
      group = resources.new_group(File.basename(dir), dir)
      # First add reference to any asset catalogs.
      Dir.glob(File.join(dir, "**/*.xcassets")) do |file|
        group.new_reference(File.basename(file))
      end
      # Add all other resources, ignoring files in existing asset catalogs
      Dir.glob(File.join(dir, "**/*.{#{RESOURCE_EXTENSIONS.join(",")}}"))
        .reject {|f| f[%r{.*\.xcassets/.*}] }.each do |file|
        group.new_reference(file.sub(dir + '/', ''))
      end
    end
  end

  def add_pods
    Dir.glob("#{pods.path}/**/*.h") do |file|
      pods.new_reference(file)
    end
  end

  def add_frameworks
    DEFAULT_FRAMEWORKS.each do |framework|
      target.add_system_framework framework
    end

    extra_frameworks.each { |framework| add_extra_framework framework }
  end

  def extra_frameworks
    Motion::Project::App.config.vendor_projects.select { |vp| vp.opts[:ib] }
  end

  def add_extra_framework(framework)
    deployment_target = Motion::Project::App.config.deployment_target
    framework_name = framework.path.split('/').last
    framework_group = project.new_group(framework_name)
    framework_group.path = File.join(project_path, framework.path)
    framework_target = project.new_target(
      :framework, framework_name, platform, deployment_target)

    Dir.glob("#{framework.path}/**/*.{h,m}") do |file|
      file_ref = framework_group.new_file File.join(project_path, file)
      framework_target.add_file_references([file_ref])
    end
  end

  def ib_project_path
    File.join(project_path, IB_PROJECT_NAME)
  end

end
