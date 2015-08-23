require 'test/unit'
require 'stringio'
require_relative  'di_graph.rb'


class TestDijkstra < Test::Unit::TestCase

  def setup
    @buf = <<-EOD
1	80,982	163,8164	170,2620	145,648	200,8021	173,2069 92,647	26,4122	140,546	11,1913	160,6461	27,7905	40,9047	150,2183 61,9146	159,7420	198,1724	114,508	104,6647	30,4612 99,2367	138,7896	169,8700	49,2437	125,2909	117,2597	55,6399	

    EOD
  end

  def test_file_read
    g1 = DiGraph.create_fm_adj_lst(StringIO.new(@buf))
    assert_equal 28, g1.num_nodes
  end
  
  def test_file_pa5
    File.open("dijkstraData.txt", "r") do |fh|
      g1 = DiGraph.create_fm_adj_lst(fh)
      assert_equal 200, g1.num_nodes
      assert_equal [8200], g1.weights(Node.new(6), Node.new(141))
      assert_equal [5594], g1.weights(Node.new(6), Node.new(98))
      assert_equal [9006], g1.weights(Node.new(6), Node.new(3))
      assert_equal [4899], g1.weights(Node.new(200), Node.new(54))
      assert_equal [1000000], g1.weights(Node.new(1), Node.new(199))
      assert_equal [1000000], g1.weights(Node.new(1), Node.new(81))
    end
  end
end

