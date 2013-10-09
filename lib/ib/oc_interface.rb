class IB::OCInterface
  attr_reader :sub_class, :super_class, :outlets,
    :outlet_collections, :actions, :path

  class Outlet < Struct.new(:variable, :type); end
  class OutletCollection < Struct.new(:variable, :type); end
  class Action < Struct.new(:variable, :arg, :return_type); end

  def initialize(params)
    @params            = params
    @sub_class         = params[:class][0][0]
    @super_class       = params[:class][0][1]
    @outlets           = create_instances(Outlet, params[:outlets])
    @outlet_collection = create_instances(OutletCollection, params[:outlet_collections])
    @actions           = create_instances(Action, params[:actions])
    @path              = params[:path]
  end

  def [](key)
    @params[key]
  end

  def super_class
    @super_class ||
      ((@sub_class == 'AppDelegate') ? 'UIResponder <UIApplicationDelegate>' : 'NSOBject')
  end

  def sub_class_dependencies
    [
      @super_class,
      extract_types(@outlets),
      extract_types(@outlet_collections),
    ].flatten.compact.select do |klass|
      klass != 'id'
    end
  end

  def has_class?(klass)
    [sub_class, *sub_class_dependencies].any? do |k|
      k == klass
    end
  end

  def has_sub_class?(klass)
    sub_class == klass
  end

  private
  def create_instances(klass, array)
    (array||[]).map do |x|
      klass.new(*x)
    end
  end

  def extract_types(array)
    (array||[]).map do |x|
      x.type
    end.compact
  end

end
