# -*- encoding : utf-8 -*-
module IB
  class Generator
    class RenderingHelper

      def initialize(build_platform, files)
        @build_platform = build_platform
        @files = files
      end

      def ib_version
        IB::VERSION
      end

      def ios_project?
        @build_platform == :ios
      end

      def osx_project?
        @build_platform == :osx
      end

      def framework_headers
        headers = ''
        if defined?(Motion::Project::App.config.frameworks)
          Motion::Project::App.config.frameworks.each do |framework|
            headers << "\#import <#{framework}/#{framework}.h>\n"
          end
        else
          headers << "#import <Foundation/Foundation.h>\n"
          headers << "#import <CoreData/CoreData.h>\n"
          if ios_project?
            headers << "#import <UIKit/UIKit.h>\n"
          elsif osx_project?
            headers << "#import <Cocoa/Cocoa.h>\n"
          end
        end
        headers
      end

    end
  end
end
