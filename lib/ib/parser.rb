class IB::Parser
  NAME_REGEX = /[a-zA-Z][_a-zA-Z0-9]*/
  CLASS_REGEX  = /^[ \t]*class[ \t]+(#{NAME_REGEX})[ \t]*<[ \t]*(#{NAME_REGEX})/
  OUTLET_REGEX = /^[ \t]+(ib_)?outlet(_accessor)?[ \t]+:(#{NAME_REGEX})[ \t]*?(,[ \t]*['"]?(#{NAME_REGEX}))?/
  OUTLET_COLLECTION_REGEX = /^[ \t]+(ib_)?outlet_collection(_accessor)?[ \t]+:(#{NAME_REGEX})[ \t]*?(,[ \t]*['"]?(#{NAME_REGEX}))?/
  METHOD_REF_REGEX = /^[ \t]+(ib_action)[ \t]:(#{NAME_REGEX})/
  METHOD_DEF_REGEX = /^[ \t]+(def)[ \t](#{NAME_REGEX})([ \t(]+)?(#{NAME_REGEX})?([ \t)]*)(#.*)?$/
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
    src.scan(OUTLET_REGEX).map do |groups|
      [groups[2], groups[4] || "id"]
    end
  end

  def find_outlet_collections src
    src.scan(OUTLET_COLLECTION_REGEX).map do |groups|
      [groups[2], groups[4] || "id"]
    end
  end

  def find_actions src
    src.scan(ACTION_REGEX).map do |groups|
      if groups[0] == "def"
        [groups[1], groups[3]]
      elsif groups[6] == "ib_action"
        [groups[7], 'sender']
      else
        nil
      end
    end.compact.uniq {|action| action[0]}
  end
end
