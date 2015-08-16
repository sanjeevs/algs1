require_relative "node.rb"
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
      n1, n2 = line.split
      e1 = Edge.new(Node.new(n1.to_i), Node.new(n2.to_i))
      g1.add_edge(e1)
    end
    # Just to make the algo predictable we would like to pick the lower
    # numbered neighbors first.
    #Also keep the nodes in descending order
    g1.nodes.sort!
    g1.nodes.each do |n|
      g1.neighbors(n).sort!
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

  def add_edge(e1)
    #Edge is from tail to head
    add_node(e1.tail) unless @nodes.include?(e1.tail)
    add_node(e1.head) unless @nodes.include?(e1.head)
    from = @nodes[@nodes.index(e1.tail)]
    to = @nodes[@nodes.index(e1.head)]
    @neighbors[from] << to
  end

  def neighbors(n)
    return @neighbors[n]
  end

  def unexplored_neighbors(n)
    return @neighbors[n].select {|x| x.explored == false }
  end

  def num_nodes;
    @nodes.size
  end
  def num_edges
    result = 0
    @neighbors.each_key do |k|
      result += @neighbors[k].size
    end
    return result 
  end

  def reverse
    rg = DiGraph.new
    @neighbors.each_pair do |node, neighbors|
      n1 = node.dup
      neighbors.each do |src|
        e1 = Edge.new(src.dup, n1)
        rg.add_edge(e1)
      end
    end
    return rg
  end


  def DFS
    result = []
    @timetick = 1
    nodes.each do |n|
      @leader = n.name
      result << DFS_visit(n) unless n.is_explored?
    end
    return result
  end

  def DFS_visit(root)
    stack = []
    root.explored = true
    root.leader = @leader
    stack.push(root)
    result = []
    until(stack.empty?) 
      node = stack[-1]
      if(unexplored_neighbors(node).empty?)
        n = stack.pop
        n.finish_time = @timetick
        @timetick += 1
        result << n
      else
        unexplored_neighbors(node).each do |next_hop|
          next_hop.explored = true
          next_hop.leader = @leader
          stack.push(next_hop) 
          @timetick += 1
        end
      end
    end
    return result
  end

  def find_node_by_name(name)
    lst = @nodes.select {|x| x.name == name }
    lst[0]
  end 

  def nodes_by_finish_time
    node_lst = @nodes.sort do |a, b|
        a.finish_time <=> b.finish_time
    end
    return node_lst.map {|x| x.name } 
  end

  def nodes_by_dec_finish_time
    node_lst = @nodes.sort do |a, b|
        b.finish_time <=> a.finish_time
    end
    return node_lst.map {|x| x.name } 
  end

  def kosaraju_scc
    grev = reverse
    grev.DFS
    node_name_lst = grev.nodes_by_dec_finish_time

    # Run DFS on each node finding the leader
    @timetick = 1
    result = []
    node_name_lst.each do |n|
      root = find_node_by_name(n)
      unless root.is_explored?
        @leader = n
        result << DFS_visit(root)
      end
    end

    scc = {}
    nodes.each do |n|
      scc[n.leader] = [] unless scc.has_key?(n.leader) 
      scc[n.leader] << n.name
    end

    result = []
    scc.each_key do |k|
      result << scc[k]
    end
    return result 
  end

  def to_s
    @nodes.each do |node|
      print "#{node.name}=>"
      @neighbors[node].each do |n|
        print "#{n.name},"
      end
      puts ""
    end
    puts ""
  end


end
