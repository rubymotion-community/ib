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

      def generate_type type
        type == "id" ? type : "#{type} *"
      end

      def generate_action action
        action[1] ? "#{action[0]}:(#{action[2] ? "#{action[2]}*" : 'id'}) #{action[1]}" : "#{action[0]}"
      end

    end
  end
end
