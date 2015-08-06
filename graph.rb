class Edge
  attr_accessor :name, :end1, :end2
  def initialize(name, n1, n2)
    @name = name
    if n1 < n2
      @end1 = n1
      @end2 = n2
    else
      @end1 = n2
      @end2 = n1
    end
  end

  def eql?(e)
    (end1 == e.end1) && (end2 == e.end2)
  end

  def hash
    end1 ^ end2
  end

  def to_s
    "End1=#{end1},End2=#{end2}"
  end
end

class Graph
  def initialize(fh)
    @nodes = []
    @edges = [] 
    @neighbors = {}
    @endpoints = {}
    @duplicate_edges = {}
    num_edges = 0 

    fh.each_line do |line|
      nodes = line.chomp.split.map {|x| x.to_i}
      src = nodes[0]
      neighbors = nodes[1..-1]
      raise KeyError, "Key already exists" if @neighbors.has_key?(src)
      @nodes << src
      @neighbors[src.to_i] = neighbors

      # Fill the edges
      neighbors.each do |n|
        # Convention to detect duplicate edges
        e = Edge.new(src, n)
        if not @duplicate_edges.has_key?(e)
          @edges << num_edges
          @endpoints[num_edges] = e 
          @duplicate_edges[e] = 1
          num_edges += 1
          puts "Adding edge #{num_edges}:#{e}"
        end
      end

    end
  end

  def num_nodes
    @nodes.size
  end

  def num_edges
    @edges.size
  end

  def neighbors(node)
    @neighbors[node]
  end

  def endpoints(edge_name)
    e = @endpoints[edge]
    puts @endpoints.to_s
    #[e.end1, e.end2]
  end
end
