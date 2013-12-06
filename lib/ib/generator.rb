# -*- encoding : utf-8 -*-
require 'erb'
require 'tilt/erb'
require 'ib/generator/rendering_helper'

class IB::Generator
  def initialize motion_template_type
    # NOTE: motion_template_type equal to Motion::Project::App.template
    #       but, this class use its value for judging build platform.
    @build_platform = motion_template_type
  end

  def absolute_template_path path
    File.expand_path(File.join(File.dirname(__FILE__), path))
  end

  def render_stub_file path, files
    template = Tilt::ERBTemplate.new(absolute_template_path(path), { :trim => '<>' })
    template.render(RenderingHelper.new(@build_platform, files))
  end

  def write files, dest
    files = IB::Parser.new.find_all(files)

    FileUtils.mkpath dest

    File.open("#{dest}/Stubs.h", 'w') do |f|
      f.write render_stub_file('generator/templates/Stubs.h.erb', files)
    end

    File.open("#{dest}/Stubs.m", 'w') do |f|
      f.write render_stub_file('generator/templates/Stubs.m.erb', files)
    end
  end

end
