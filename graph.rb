class Graph
  def initialize(fh)
    @neighbors = {}
    fh.each_line do |line|
      nodes = line.chomp.split.map {|x| x.to_i}
      src = nodes[0]
      neighbors = nodes[1..-1]
      raise KeyError, "Key already exists" if @neighbors.has_key?(src)
      @neighbors[src.to_i] = neighbors
    end
  end

  def num_nodes
    @neighbors.keys.size
  end

  def neighbors(node)
    @neighbors[node]
  end
end
