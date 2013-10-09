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

    module TSortable
      def to_node
        sub_class_dependencies_nodes = sub_class_dependencies.inject({}) do |sum, i|
          sum.merge!({ i => [] })
        end

        (super_class ? node_with_super_class : node_without_super_class).
          merge(sub_class_dependencies_nodes)
      end

      def node_with_super_class
        {
          sub_class   => sub_class_dependencies,
          super_class => [],
        }
      end

      def node_without_super_class
        { sub_class => sub_class_dependencies }
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
        files.select do |file, interfaces|
          interfaces.any?{|i| i.has_sub_class?(klass) }
        end.keys[0]
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
    def struct_class_node
      list_of_hash = @files.values.flatten.map {|i| i.extend TSortable }.map(&:to_node)
      list_of_hash.inject(TSortHash.new) do |sum, x|
        sum.merge!(x)
      end
    end
  end
end
