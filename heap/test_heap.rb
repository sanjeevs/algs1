require 'test/unit'
require_relative 'heap.rb'
class TestHeap < Test::Unit::TestCase
  def setup
    @heap = Heap.new
    (0..15).each do |i|
      @heap.insert(i)
    end
  end

  def test_sanity
    assert_equal true, @heap.sanity_check
  end

  def test_root
    assert_equal 0, @heap.root
  end

  def test_parent
    (1..2).each {|x| assert_equal 0, @heap.parent(x) }
    (3..4).each {|x| assert_equal 1, @heap.parent(x) }
    (13..14).each {|x| assert_equal 6, @heap.parent(x) }
  end

  def test_children
    assert_equal 1, @heap.left_child(0)
    assert_equal 2, @heap.right_child(0)
    assert_equal 13, @heap.left_child(6)
    assert_equal 14, @heap.right_child(6)
    assert_equal 7, @heap.left_child(3)
    assert_equal 8, @heap.right_child(3)
  end

  def test_swap
    @heap.swap_index(1, 3)
    assert_equal 3, @heap.node(1) 
    assert_equal 1, @heap.node(3)
  end

  def test_invalid_access
    assert_raise IndexError do
      @heap.parent(16)
    end
  end
  
  def test_bubble_down1
    heap1 = Heap.new
    heap1.insert(16)
    (0..15).each do |i|
      heap1.insert(i)
    end
    heap1.bubble_down(0)
    assert_equal [0,2,1,6,3,4,5,14,7,8,9,10,11,12,13,16,15], heap1.arr
  end
  
  def test_bubble_up1
    heap1 = @heap
    heap1.arr << 0
    puts heap1.arr.to_s
    heap1.bubble_up(15)
    assert_equal [0,0,2,1,4,5,6,3,8,9,10,11,12,13,14,15,7], heap1.arr
  end

end
