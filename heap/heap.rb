class Heap
  def initilaize
    @arr = []
  end

  def parent(index)
    raise IndexError unless index < @arr.size
    (index/2.0).ceil - 1
  end

  def children(index)
  end

  def left_child(index)
  end

  def right_child(index)
  end

  def insert(node)
    @arr << node
    bubble_up
  end

  def extract_min
    raise IndexError, "No entries in the heap" if @arr.empty?
    min = @arr.shift
    bubble_down
  end

  def bubble_up
  end

  def bubble_down
  end
end


