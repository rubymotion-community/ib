module IB

  def ib_outlet name, type = "id"
  end

  def outlet name, type = "id"
    attr_accessor name
  end

  def ib_outlet_collection name, type = "id"
  end

  def outlet_collection name, type = "id"
    attr_accessor name
  end

  def ib_action name, type = "id"
  end

end
