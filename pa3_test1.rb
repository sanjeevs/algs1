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

    @data1_del3 = <<-EOD
    2 1 4
    1 2 4 7
    4 2 5 1
    5 4 7 6 8
    6 5 7 8
    7 1 5 6 8
    8 7 5 6
    EOD

    @data2 = <<-EOD
    1 2 3 4
    2 1 3 4
    3 1 2 4
    4 1 2 3 5
    5 4 6 7 8
    6 5 7 8
    7 5 6 8
    8 5 6 7  
    EOD

    @data3 = <<-EOD
1 19 15 36 23 18 39 
2 36 23 4 18 26 9
3 35 6 16 11
4 23 2 18 24
5 14 8 29 21
6 34 35 3 16
7 30 33 38 28
8 12 14 5 29 31
9 39 13 20 10 17 2
10 9 20 12 14 29
11 3 16 30 33 26
12 20 10 14 8
13 24 39 9 20
14 10 12 8 5
15 26 19 1 36
16 6 3 11 30 17 35 32
17 38 28 32 40 9 16
18 2 4 24 39 1
19 27 26 15 1
20 13 9 10 12
21 5 29 25 37
22 32 40 34 35
23 1 36 2 4
24 4 18 39 13
25 29 21 37 31
26 31 27 19 15 11 2
27 37 31 26 19 29
28 7 38 17 32
29 8 5 21 25 10 27
30 16 11 33 7 37
31 25 37 27 26 8
32 28 17 40 22 16
33 11 30 7 38
34 40 22 35 6
35 22 34 6 3 16
36 15 1 23 2
37 21 25 31 27 30
38 33 7 28 17 40
39 18 24 13 9 1
40 17 32 22 34 38 
    EOD

    @data4 = <<-EOD
1 2 3 4 5
2 3 4 1
3 4 1 2
4 1 2 3 8
5 1 6 7 8
6 7 8 5
7 8 5 6
8 4 6 5 7
    EOD
  end

  def test_sap1
    graph = Graph.create_fm_text(StringIO.new(@data1))
    assert_equal 8, graph.num_nodes
    assert_equal [2, 3, 4, 7], graph.neighbors(Node.new("1")).map {|x| x.name.to_i }
    assert_not_equal [3, 4, 7], graph.neighbors(Node.new("1")).map {|x| x.name.to_i }
    assert_equal [1, 3, 4], graph.neighbors(Node.new("2")).map {|x| x.name.to_i }
    assert_equal [1, 2, 4], graph.neighbors(Node.new("3")).map {|x| x.name.to_i }
    assert_equal [1, 2, 3, 5], graph.neighbors(Node.new("4")).map {|x| x.name.to_i }
    assert_equal [4, 6, 7, 8], graph.neighbors(Node.new("5")).map {|x| x.name.to_i }
    assert_equal [5, 7, 8], graph.neighbors(Node.new("6")).map {|x| x.name.to_i }
    assert_equal [1, 5, 6, 8], graph.neighbors(Node.new("7")).map {|x| x.name.to_i }
    assert_equal [5, 6, 7], graph.neighbors(Node.new("8")).map {|x| x.name.to_i }
    assert_equal 14, graph.num_edges
    assert_equal true, graph.check
  end

  def test_duplicate_node
    err_data = <<-EOD
    1 2 3 4
    1 3
    EOD
    graph = Graph.create_fm_text(StringIO.new(err_data))  
    assert_equal 4, graph.num_nodes
  end
  
  def test_data1_del3
    graph = Graph.create_fm_text(StringIO.new(@data1_del3))
    assert_equal 7, graph.num_nodes
    assert_equal [1, 4], graph.neighbors(Node.new("2")).map {|x| x.name.to_i }
    assert_equal [2, 4, 7], graph.neighbors(Node.new("1")).map {|x| x.name.to_i }
    assert_equal [2, 1, 5], graph.neighbors(Node.new("4")).map {|x| x.name.to_i }
    assert_equal [4, 7, 6, 8], graph.neighbors(Node.new("5")).map {|x| x.name.to_i }
    assert_equal [5, 7, 8], graph.neighbors(Node.new("6")).map {|x| x.name.to_i }
    assert_equal [1, 5, 6, 8], graph.neighbors(Node.new("7")).map {|x| x.name.to_i }
    assert_equal [5, 6, 7], graph.neighbors(Node.new("8")).map {|x| x.name.to_i }
    assert_equal 11, graph.num_edges
    assert_equal true, graph.check
  end

  def test_del3
    graph = Graph.create_fm_text(StringIO.new(@data1))
    graph.del_node(Node.new("3"))
    assert_equal 7, graph.num_nodes
    assert_equal 11, graph.num_edges
    assert_equal [1, 4], graph.neighbors(Node.new("2")).map {|x| x.name.to_i }
    assert_equal [2, 4, 7], graph.neighbors(Node.new("1")).map {|x| x.name.to_i }
    assert_equal [1, 2, 5], graph.neighbors(Node.new("4")).map {|x| x.name.to_i }
    assert_equal [4, 6, 7, 8], graph.neighbors(Node.new("5")).map {|x| x.name.to_i }
    assert_equal [5, 7, 8], graph.neighbors(Node.new("6")).map {|x| x.name.to_i }
    assert_equal [1, 5, 6, 8], graph.neighbors(Node.new("7")).map {|x| x.name.to_i }
    assert_equal [5, 6, 7], graph.neighbors(Node.new("8")).map {|x| x.name.to_i }
  end
  
  def test_x
    graph = Graph.create_fm_text(StringIO.new(@data1))
    graph.del_node(Node.new("5"))
    assert_equal [1, 2, 3], graph.neighbors(Node.new("4")).map {|x| x.name.to_i }
  end
  def test_del5
    graph = Graph.create_fm_text(StringIO.new(@data1))
    graph.del_node(Node.new("5"))
    assert_equal 7, graph.num_nodes
    assert_equal [2, 3, 4, 7], graph.neighbors(Node.new("1")).map {|x| x.name.to_i }
    assert_not_equal [3, 4, 7], graph.neighbors(Node.new("1")).map {|x| x.name.to_i }
    assert_equal [1, 3, 4], graph.neighbors(Node.new("2")).map {|x| x.name.to_i }
    assert_equal [1, 2, 4], graph.neighbors(Node.new("3")).map {|x| x.name.to_i }
    assert_equal [7, 8], graph.neighbors(Node.new("6")).map {|x| x.name.to_i }
    assert_equal [1, 6, 8], graph.neighbors(Node.new("7")).map {|x| x.name.to_i }
    assert_equal [6, 7], graph.neighbors(Node.new("8")).map {|x| x.name.to_i }
    assert_equal true, graph.check
  end
  def test_del_empty
    graph = Graph.create_fm_text(StringIO.new(@data1))
    (1..8).each do |i|
      graph.del_node(Node.new("#{i}"))
      assert_equal 8 - i, graph.num_nodes
    end
  end
  def test_add_node
    graph = Graph.new
    (1..10).each do |i|
      graph.add_node(Node.new(i.to_s))
      assert_equal i, graph.num_nodes
    end
  end
  
  def test_parallel_edges
    graph = Graph.new
    n1 = Node.new("n1")
    n2 = Node.new("n2")
    graph.add_node(n1)
    graph.add_node(n2)
    (1..10).each do |i|
      graph.add_edge(Edge.new(n1, n2))
      assert_equal i, graph.num_edges
    end
    assert_equal 10, graph.num_edges
    (1..10).each do |i|
      graph.del_edge(Edge.new(n1, n2))
      assert_equal 10-i, graph.num_edges
    end
  end
 
 
  def test_contract1
    data  = <<-EOD
    1 2 3
    3 1 2 4
    2 1 3 4
    4 3 2
    EOD
    graph = Graph.create_fm_text(StringIO.new(data))
    assert_equal 5, graph.num_edges  
    graph.contract!(Edge.new(Node.new("1"), Node.new("3")))
    assert_equal 4, graph.num_edges
    graph.contract!(Edge.new(Node.new("1_3"), Node.new("2")))
    assert_equal 2, graph.num_edges
  end
  
  def test_random_contraction1
    result = []
    100.times do  
      graph = Graph.create_fm_text(StringIO.new(@data1))
      graph.random_contraction!
      result << graph.num_edges
    end
    assert_equal 2, result.min
  end

  def test_random_contraction2
    result = []
    100.times do  
      graph = Graph.create_fm_text(StringIO.new(@data2))
      graph.random_contraction!
      result << graph.num_edges
    end
    assert_equal 1, result.min
  end
  
  def test_random_contraction3
    result = []
    1024.times do  
      graph = Graph.create_fm_text(StringIO.new(@data3))
      graph.random_contraction!
      result << graph.num_edges
    end
    assert_equal 3, result.min
  end
  
  def test_random_contraction4
    result = []
    100.times do  
      graph = Graph.create_fm_text(StringIO.new(@data4))
      graph.random_contraction!
      result << graph.num_edges
    end
    assert_equal 2, result.min
  end
  
  def test_karger
    File.open("kargerMinCut.txt") do |fh|
      graph = Graph.create_fm_text(fh)
      assert_equal 200, graph.num_nodes
      expected = [193,185,79,108,8,158,87,73,81,115,39,64,178,132,27,68,127,84,14,52,200,97,6,93].sort
      assert_equal expected, graph.neighbors(Node.new("25")).map {|x| x.name.to_i }.sort
    end
  end
  
  def test_krager_contraction
    result = []
    10.times do  
      File.open("kargerMinCut.txt") do |fh|
        graph = Graph.create_fm_text(fh)
        graph.random_contraction!
        result << graph.num_edges
      end
    end
    puts "RESULT:#{result.min}"
  end

end
