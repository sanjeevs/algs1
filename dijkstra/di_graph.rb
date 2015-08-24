require_relative "node.rb"
require_relative "edge.rb"
# A directed graph.
# Is a collection of nodes.

class DiGraph
  attr_reader :nodes
  attr_reader :distance_vec
  def initialize
    @nodes = []
    @neighbors = {}
    @distance_vec = {}
  end

  def self.create_fm_adj_lst(fh)
    g1 = DiGraph.new
    fh.each_line do |line|
      elements = line.split()
      tail = elements[0]
      elements.shift
      elements.each do |element|
        head,weight = element.split(',')
        e1 = Edge.new(Node.new(tail.to_i), Node.new(head.to_i))
        g1.add_edge(e1, weight.to_i)
      end
    end
    return g1
  end

  # Add a new node to the graph.
  # Node must not exist.
  def add_node(n1)
    raise "Non empty node. Delete it first" if @nodes.include?(n1)
    @nodes << n1
    @neighbors[n1] = [] 
    return @nodes[-1]
  end

  def add_edge(e1, weight)
    #Edge is from tail to head
    add_node(e1.tail) unless @nodes.include?(e1.tail)
    add_node(e1.head) unless @nodes.include?(e1.head)
    from = @nodes[@nodes.index(e1.tail)]
    to = @nodes[@nodes.index(e1.head)]
    @neighbors[from] << [to, weight]
  end

  def num_nodes
    @nodes.size
  end

  # Return the weights between tail to head. There may be multiple paths (parallel paths) and so return
  # an array of weights.
  def weights(tail, head)
    result = @neighbors[tail].select {|pair| pair[0] == head}
    weights = []
    result.each {|pair| weights << pair[1] }
    # Given that if the path does not exist then the distance is inf.
    weights << 1000000 if weights.empty?
    return weights
  end

  def shortest_path(src_node)
    @distance_vec[src_node] = 0
    src_node.explored = true
    dijkstra(src_node)
    distance = []
    @distance_vec.keys.sort.each do |key|
      distance << @distance_vec[key]
    end
    distance
  end

  def dijkstra(src_node)
    min = 2000000
    node = nil
    puts "SrcNode is #{src_node.name}"
    @neighbors[src_node].each do |pair|
      if !pair[0].is_explored? and pair[1] < min
        min = pair[1]
        node = pair[0]
      end
    end
    return nil unless node
    @nodes.each do |node|
      @distance_vec[node] = @distance_vec[src_node] + weights(src_node, node).min
    end 
    node.explored = true
    return dijkstra(node)
  end

  def to_s
    @nodes.each do |node|
      print "#{node.name}=>"
      @neighbors[node].each do |pair|
        print "#{pair[0].name}:#{pair[1]},"
      end
      puts ""
    end
    puts ""
  end


end
