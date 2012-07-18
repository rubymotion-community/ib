class IB::Parser
  def find_all(dir)
    all = {}
    Dir.glob("#{dir}/**/*.rb") do |file|
      if info = find(file)
        all[file] = info
      end
    end
    all
  end

  def find(path)
    src = File.read(path)
    info = {class: find_class(src)}
    
    return false if info[:class].length == 0

    info[:outlets] = find_outlets(src)

    info[:actions] = find_actions(src)

    info[:path] = path

    info
  end

  def find_class src
    src.scan /^\s*class\s+([a-zA-Z][_a-zA-Z0-9]+)\s*<\s*([a-zA-Z][_a-zA-Z0-9]+)/
  end

  def find_outlets src
    outlets = []
    src.scan /^\s+ib_outlet\s+:([a-zA-Z][_a-zA-Z0-9]*)\s*?(,\s*['"]?([a-zA-Z][_a-zA-Z0-9]+))?/ do |groups|
      outlets << [groups[0], groups[2] || "id"]
    end
    outlets
  end

  def find_actions src
    src.scan /^\s+ib_action\s+:([a-zA-Z][_a-zA-Z0-9]*)/
  end
end