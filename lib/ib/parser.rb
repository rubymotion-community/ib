class IB::Parser
  NAME_REGEX = /[a-zA-Z][_a-zA-Z0-9]*/
  CLASS_REGEX  = /^[ \t]*class[ \t]+(#{NAME_REGEX})([ \t]*<[ \t]*(#{NAME_REGEX}))?/
  OUTLET_REGEX = /^[ \t]+(ib_)?outlet(_accessor)?[ \t]+:(#{NAME_REGEX})[ \t]*?(,[ \t]*['"]?(#{NAME_REGEX}))?/
  OUTLET_COLLECTION_REGEX = /^[ \t]+(ib_)?outlet_collection(_accessor)?[ \t]+:(#{NAME_REGEX})[ \t]*?(,[ \t]*['"]?(#{NAME_REGEX}))?/
  METHOD_ARGUMENT_REGEX = /(#{NAME_REGEX})(?:[ \t]*=[^,#)]*)?/
  METHOD_REF_REGEX = /^[ \t]+(ib_action)[ \t]:(#{NAME_REGEX})[ \t]*?(,[ \t]*['"]?(#{NAME_REGEX}))?/
  METHOD_DEF_REGEX = /^[ \t]+(def)[ \t]#{METHOD_ARGUMENT_REGEX}([ \t(]+)?#{METHOD_ARGUMENT_REGEX}?([ \t)]*)(#.*)?$/
  ACTION_REGEX = Regexp.union METHOD_DEF_REGEX, METHOD_REF_REGEX

  def find_all(dir_or_files)
    all = {}
    files = case dir_or_files
    when Array
      dir_or_files.flatten
    else
      Dir.glob("#{dir_or_files.to_s}/**/*.rb").to_a
    end

    files.each do |file|
      infos = find(file)
      if infos.length > 0
        all[file] = infos
      end
    end
    all
  end

  def find(path)
    src = File.read(path)
    offsets = []
    src.scan CLASS_REGEX do |b|
      offsets << $~.offset(0)
    end

    return [] if offsets.length == 0
    infos = []
    pairs = offsets.map {|o| o[0]}

    pairs << src.length
    (pairs.length - 1).times do |i|
      s = src[pairs[i], pairs[i+1]]
      info = {:class => find_class(s)}

      info[:outlets] = find_outlets(s)
      info[:outlet_collections] = find_outlet_collections(s)
      info[:actions] = find_actions(s)

      info[:path] = path

      # skip empty classes
      if info[:outlets].empty? &&
        info[:outlet_collections].empty? &&
        info[:actions].empty? && info[:class][0][1].nil?
        next
      end

      infos << info
    end

    infos
  end

  def find_class src
    src.scan(CLASS_REGEX).map do |groups|
      [groups[0], groups[2]]
    end
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
        [groups[1], groups[3], nil]
      elsif groups[6] == "ib_action"
        [groups[7], 'sender', groups[9]]
      else
        nil
      end
    end.compact.uniq {|action| action[0]}
  end
end
