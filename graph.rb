require_relative "node.rb"
require_relative "edge.rb"
# A graph.
class Graph
  attr_reader :nodes, :edges
  def initialize
    @nodes = [] 
    @edges =  [] 
    @incident_map = {}
  end

  # Add a new node to the graph.
  # Node must not exist.
  def add_node(n1)
    raise ArgumentError, "Duplicate node name #{n1.name}" if @nodes.find_index(n1)
    @nodes << n1
    @incident_map[n1] = []
  end

  # Add a unidirectional edge to the graph.
  # The end point must have valid nodes that are already added to the graph.
  # parallel edges are possible. So the edge may have the same end points.
  def add_edge(edge)
    @edges << edge
    add_node(edge.n1) unless @nodes.find_index(edge.n1)
    add_node(edge.n2) unless @nodes.find_index(edge.n2)
    @incident_map[edge.n1] << edge
    @incident_map[edge.n2] << edge
  end 

  def del_edge(edge)
    i1 = @incident_map[edge.n1].find_index(edge)
    @incident_map[edge.n1].delete_at(i1)
    i2 = @incident_map[edge.n2].find_index(edge)
    @incident_map[edge.n2].delete_at(i2)
    i = @edges.find_index(edge)
    @edges.delete_at(i)
  end

  def del_node(node)
    raise ArgumentError, "Node to be deleted not present" unless @nodes.find_index(node)
    next_hops = @incident_map[node].dup
    next_hops.each do |edge|
      del_edge(edge)
    end
    @nodes.delete(node) 
  end

  def contract!(edge)
    a = edge.n1
    b = edge.n2
    
    del_edge(edge)
    new_node_incident_lst = @incident_map[a].dup + @incident_map[b].dup
    del_node edge.n1
    del_node edge.n2
    x =  Node.new(edge.n1.name + "_" + edge.n2.name) 
    add_node x
    new_node_incident_lst.each do |e|
      e.n1 = x if e.n1 == a or e.n1 == b
      e.n2 = x if e.n2 == a or e.n2 == b
      add_edge e unless e.self_loop?
    end 
  end
  
  def random_contraction!
    while num_non_parallel_edges > 2 do
      edge = @edges[rand(num_edges)]
      contract!(edge)
    end
  end
  # Create a graph from a string in the following format
  # Node1 Neighbor1 Neighbor2 .........
  # Node2 Neighbor3 ..........
  def self.create_fm_text(fh)
    g1 = Graph.new
    fh.each_line do |line|
      nodes = line.chomp.split
      src = Node.new(nodes[0])
      g1.add_node(src) unless g1.node_exists?(src)
      neighbors = nodes[1..-1]
      # Fill the edges
      neighbors.each do |n|
        e = Edge.new(src, Node.new(n))
        g1.add_edge(e) unless g1.edge_exists?(e)
      end
    end
    return g1
  end

  def neighbors(node)
    incident_lst = @incident_map[node]
    next_hop = []
    incident_lst.each do |e|
      next_hop << e.n1 unless e.n1 == node
      next_hop << e.n2 unless e.n2 == node
    end
    return next_hop
  end

  # Debug hook, Check that the graph is consistent.
  #
  def check
    raise "Non unique node entries" unless nodes.uniq == nodes
    raise "Non unique edge entries" unless edges.uniq == edges
    @edges.each do |e|
      raise "self loop" if e.n1 == e.n2
      raise "wrong order" unless e.n1 < e.n2
      raise "edge not found in n1 incident list" unless @incident_map[e.n1].find_index(e)  
      raise "edge not found in n2 incident list" unless @incident_map[e.n2].find_index(e)
    end
    return true
  end  

  def num_nodes
    @nodes.size
  end

  def num_edges
    @edges.size
  end

  def num_non_parallel_edges
    @edges.uniq.size
  end

  def node_exists?(node)
    @nodes.find_index(node)
  end 

  def edge_exists?(edge)
    @edges.find_index(edge)
  end 

  def ==(other)
    match = @nodes.sort == other.nodes.sort \
      and @edges.sort = other.edges.sort \
      and @incident_map == other.incident_map
  end

  def dump 
    puts "Dumping #{num_nodes} nodes in graph"
    @nodes.each do |node|
      line = node.name + " "
      neighbors(node).each do |n|
        line += n.name + " "
      end
      puts line
    end
  end
end
