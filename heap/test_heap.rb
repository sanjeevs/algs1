require 'test/unit'

class TestHeap < Test::Unit::TestCase
  def setup
    @heap = Heap.new
    (0..15).each do |i|
      @heap.insert(i)
    end
  end

  def test_root
    assert_equal 0, @heap.root
  end

  def test_parent
    assert_equal nil, @heap.parent(0)
    (1..2).each {|x| assert_equal 0, @heap.parent(x) }
    (3..4).each {|x| assert_equal 1, @heap.parent(x) }
    (13..14).each {|x| assert_equal 6, @heap.parent(x) }
  end

  def test_children
    assert_equal [1,2], @heap.children(0)
    assert_equal 1, @heap.left_child(0)
    assert_equal 2, @heap.right_child(0)
    assert_equal [13,14], @heap.children(6)
    assert_equal [7,8], @heap.children(3)
  end
 
  def test_invalid_access
    assert_raise IndexError do
      @heap.parent(16)
    end
  end

end
