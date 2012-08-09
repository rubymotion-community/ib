class IB::Parser
  CLASS_REGEX  = /^\s*class\s+([a-zA-Z][_a-zA-Z0-9]+)\s*<\s*([a-zA-Z][_a-zA-Z0-9]+)/
  OUTLET_REGEX = /^\s+(ib_)?outlet(_accessor)?\s+:([a-zA-Z][_a-zA-Z0-9]*)\s*?(,\s*['"]?([a-zA-Z][_a-zA-Z0-9]+))?/
  OUTLET_COLLECTION_REGEX = /^\s+(ib_)?outlet_collection(_accessor)?\s+:([a-zA-Z][_a-zA-Z0-9]*)\s*?(,\s*['"]?([a-zA-Z][_a-zA-Z0-9]+))?/
  METHOD_REF_REGEX = /^\s+(ib_action)\s+:([a-zA-Z][_a-zA-Z0-9]*)/
  METHOD_DEF_REGEX = /^\s+(def)\s+([a-zA-Z][_a-zA-Z0-9]*)([\s(]+)([a-zA-Z][_a-zA-Z0-9]*)([\s)]*)(#.*)?$/
  ACTION_REGEX = Regexp.union METHOD_DEF_REGEX, METHOD_REF_REGEX

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
    info[:outlet_collections] = find_outlet_collections(src)
    info[:actions] = find_actions(src)

    info[:path] = path

    info
  end

  def find_class src
    src.scan CLASS_REGEX
  end

  def find_outlets src
    outlets = []
    src.scan OUTLET_REGEX do |groups|
      outlets << [groups[2], groups[4] || "id"]
    end
    outlets
  end

  def find_outlet_collections src
    outlet_collections = []
    src.scan OUTLET_COLLECTION_REGEX do |groups|
      outlet_collections << [groups[2], groups[4] || "id"]
    end
    outlet_collections
  end

  def find_actions src
    actions = []
    src.scan ACTION_REGEX do |groups|
      if groups[0] == "def"
        actions << [groups[1]]
      elsif groups[6] == "ib_action"
        actions << [groups[7]]
      end
    end
    actions.uniq
  end
end
