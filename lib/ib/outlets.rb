module IB
  
  def ib_outlet name, type = "id"
  end

  def outlet_accessor name, type = "id"
    attr_accessor name
  end

  def ib_outlet_collection name, type = "id"
  end

  def outlet_collection_accessor name, type = "id"
    attr_accessor name
  end

  def ib_action name
  end

end
