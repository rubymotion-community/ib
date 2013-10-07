require 'tsort'

module IB
  class DependencyResolver

    class TSortHash < ::Hash
      include TSort

      alias tsort_each_node each_key

      def tsort_each_child(node, &block)
        fetch(node).each(&block)
      end
    end

    attr_reader :class_nodes, :files

    def initialize(files)
      @files = files
      @class_nodes = struct_class_node
    end

    def sort_classes
      @class_nodes.tsort
    end

    def sort_files
      sort_classes.map do |klass|
        files.select do |file, class_definitions|
          has_class_in_file?(klass, class_definitions)
        end.first
      end.map do |file, _|
        file
      end.uniq.compact
    end

    def sort
      sorted_files = {}
      sort_files.each do |file|
        sorted_files.store(file, @files[file])
      end
      sorted_files
    end

    private
    def has_class_in_file?(klass, class_definitions)
      !class_definitions.select do |x|
        x[:class][0][0] == klass
      end.empty?
    end

    def has_super_class?(class_definition)
      class_definition[:class][0].size == 2      
    end

    def struct_class_node
      list_of_hash = @files.map do |file, class_definitions|
        class_definitions.map do |class_definition| create_node(class_definition) end
      end.flatten

      list_of_hash.inject(TSortHash.new) do |sum, x|
        sum.merge!(x)
      end
    end

    def create_node(class_definition)
      has_super_class?(class_definition) ?
        node_with_super_class(class_definition):
          node_without_super_class(class_definition)
    end

    def node_with_super_class(class_definition)
      {
        class_definition[:class][0][0] => [class_definition[:class][0][1]],
        class_definition[:class][0][1] => [],
      }
    end

    def node_without_super_class(class_definition)
      { class_definition[:class][0][0] => [] }
    end
  end
end
