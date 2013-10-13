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

    end
  end
end
