require "test/unit"
require "stringio"
require_relative "node.rb"
require_relative "edge.rb"
require_relative "di_graph.rb"

class TestGraph1 < Test::Unit::TestCase
  def setup
    @cormen_lst = <<-EOD
    1 2
    1 4
    2 5
    3 5
    3 6
    4 2
    5 4
    6 6
    EOD
  end

  def test_add_node1
    g1 = DiGraph.new
    g1.add_edge(Edge.new(Node.new(1), Node.new(2)))
    assert_equal 2, g1.num_nodes
    assert_equal [Node.new(2)], g1.neighbors(Node.new(1))
    assert_equal [], g1.neighbors(Node.new(2))
  end

  def test_add_10
    g1 = DiGraph.new
    (0..10).step(2) do |i|
      g1.add_edge(Edge.new(Node.new(i), Node.new(i+1)))
    end
    assert_equal 12, g1.num_nodes
    assert_equal [Node.new(1)], g1.neighbors(Node.new(0))
    assert_equal [], g1.neighbors(Node.new(1))
    assert_equal [Node.new(3)], g1.neighbors(Node.new(2))
  end

  def test_multiple_add
    g1 = DiGraph.new
    (1..10).each do |i|
      g1.add_edge(Edge.new(Node.new(0), Node.new(i)))
    end
    assert_equal 11, g1.num_nodes
    assert_equal 10, g1.neighbors(Node.new(0)).size
  end

  def test_reverse1
    g1 = DiGraph.new
    g1.add_edge(Edge.new(Node.new(1), Node.new(2)))
    g2 = g1.reverse
    g1.add_edge(Edge.new(Node.new(1), Node.new(4)))
    assert_equal 2, g2.num_nodes
    assert_equal [], g2.neighbors(Node.new(1))
    assert_equal [Node.new(1)], g2.neighbors(Node.new(2))
  end

  def test_dfs1
    adj_lst = <<-EOD
      1 2
      2 3
      3 4
      EOD
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(adj_lst))
    assert_equal 4, g1.num_nodes
    assert_equal [Node.new(2)], g1.neighbors(Node.new(1))
    assert_equal [[4,3,2,1]], g1.DFS
  end

  def test_cormen1
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(@cormen_lst))
    assert_equal 6, g1.num_nodes
    assert_equal [Node.new(2), Node.new(4)], g1.neighbors(Node.new(1))
    assert_equal [Node.new(6)], g1.neighbors(Node.new(6))
    assert_equal [[4,5,2,1],[6,3]], g1.DFS
    assert_equal [4,5,2,1,6,3], g1.nodes_by_finish_time
  end
  
  def test_reverse_cormen1
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(@cormen_lst))
    assert_equal 6, g1.num_nodes
    g2 = g1.reverse
    assert_equal [], g2.neighbors(Node.new(1))
    assert_equal [], g2.neighbors(Node.new(3))
    assert_equal [Node.new(3), Node.new(6)], g2.neighbors(Node.new(6))
    # Starts at node 2
    assert_equal [[3,5,4,1,2],[6]], g2.DFS
    node_name_lst = g2.nodes_by_dec_finish_time
  end

  def test_cormen_scc
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(@cormen_lst))
    scc = g1.kosaraju_scc
    assert_equal [[1], [2,4,5], [3], [6]], scc
  end

  def test_class_example
    @class_example = <<-EOD
    9 7
    7 8
    8 9
    6 9
    6 1
    5 6
    1 5
    4 5
    3 4
    2 3
    4 2
    EOD
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(@class_example))
    assert_equal 9, g1.num_nodes
    assert_equal 11, g1.num_edges
    assert_equal [1,9], g1.neighbors(Node.new(6))
    scc = g1.kosaraju_scc
    assert_equal [[1,5,6], [2,3,4], [7,8,9]], scc
  end

  def test_class_example_reverse
    @class_example_reverse = <<-EOD
    1 7
    4 1
    7 4
    7 9
    9 6
    6 3
    3 9
    6 8
    8 2
    2 5
    5 8
    EOD
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(@class_example_reverse))
    assert_equal 9, g1.num_nodes
    assert_equal 11, g1.num_edges
    assert_equal [3,8], g1.neighbors(Node.new(6))
    scc = g1.kosaraju_scc
    assert_equal [[1,4,7], [2,5,8], [3,6,9]], scc
  end
end

