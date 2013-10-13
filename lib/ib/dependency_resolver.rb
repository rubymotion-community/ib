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

      def merge!(a, b)
        b.each do |k, v|
          if a.key?(k)
            a[k].concat(v)
          else
            a[k] = v
          end
        end
        return a
      end
      module_function :merge!
    end

    attr_reader :dependency_graph, :files

    def initialize(files)
      @files = files
      @dependency_graph = struct_class_dependency_graph
    end

    def sort_classes
      @dependency_graph.tsort
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
    def struct_class_dependency_graph
      nodes = @files.values.flatten.map {|i| i.extend TSortable }.map(&:to_node)
      nodes.inject(TSortHash.new) do |sum, x|
        TSortable.merge!(sum, x)
      end
    end
  end
end
