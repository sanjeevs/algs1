require_relative "node.rb"
require_relative "edge.rb"
# A directed graph.
# Is a collection of nodes.

class DiGraph
  attr_reader :nodes

  def initialize
    @nodes = []
    @neighbors = {}
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
