require 'test/unit'
require 'stringio'

require_relative 'graph.rb'
class Pa3Test < Test::Unit::TestCase

  def setup
    @data1  = <<-EOD
    1 2 3 4 7
    2 1 3 4
    3 1 2 4
    4 1 2 3 5
    5 4 6 7 8
    6 5 7 8
    7 1 5 6 8
    8 5 6 7
    EOD
  end

  def test_sap1
    graph = Graph.new(StringIO.new(@data1))
    assert_equal 8, graph.num_nodes
    assert_equal [2, 3,4, 7], graph.neighbors(1)
    assert_equal [5,6,7], graph.neighbors(8)
    assert_equal 14, graph.num_edges
    assert_equal [1,3], graph.endpoints(1)
    assert_equal [7,14], graph.endpoints(14)
  end

  def xtest_duplicate_node
    err_data = <<-EOD
    1 2 3 4
    1 3
    EOD
    assert_raise KeyError do 
      Graph.new(StringIO.new(err_data))  
    end 
  end
end
