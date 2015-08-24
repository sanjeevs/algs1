class Heap
  attr_reader :arr
  attr_writer :arr
  def initialize
    @arr = []
  end

  def root
    return nil if @arr.empty?
    @arr[0]
  end

  def parent_index(index)
    (index/2.0).ceil - 1
  end
  
  def parent(index)
    raise IndexError if index >= @arr.size
    i = parent_index(index)
    return nil if i >= @arr.size
    @arr[i]
  end

  def left_index(index)
    2 * (index + 1) - 1
  end

  def left_child(index)
    i = left_index(index)
    return nil if i >= @arr.size
    return @arr[i]
  end

  def right_index(index)
    2 * (index + 1)
  end

  def right_child(index)
    i = right_index(index)
    return nil if i >= @arr.size
    return @arr[i]
  end

  
  def node(index)
    @arr[index]
  end

  def swap_index(i1, i2)
    temp = @arr[i1]
    @arr[i1] = @arr[i2]
    @arr[i2] = temp
  end

  def hash_swap(index)
    parent = @arr[index]
    if left_child(index)
      if right_child(index)
        if left_child(index) < right_child(index) and parent > left_child(index)
          swap_index(left_index(index), index)
          return left_index(index)
        elsif right_child(index) < left_child(index) and parent > right_child(index)
          swap_index(right_index(index), index)
          return right_index(index)
        end
      elsif parent > left_child(index)
        swap_index(left_index(index), index)
        return left_index(index)
      end
    end
    return -1
  end

  def insert(node)
    @arr << node
    #bubble_up
  end

  def extract_min
    raise IndexError, "No entries in the heap" if @arr.empty?
    min = @arr.shift
    bubble_down
  end

  def bubble_up(i)
    return nil if i == 0 
    index = @arr[parent_index(i)]
    parent = @arr[index]
    if left_child(index)
      if right_child(index)
        if left_child(index) < right_child(index) and parent > left_child(index)
          swap_index(left_index(index), index)
          bubble_up(index)
        elsif right_child(index) < left_child(index) and parent > right_child(index)
          swap_index(right_index(index), index)
          bubble_up(index)
        end
      elsif parent > left_child(index)
        swap_index(left_index(index), index)
        bubble_up(index)
      end
    end
  end

  def bubble_down(index)
    index = hash_swap(index) until index == -1 
  end


  def sanity_check
    @arr.each_index do |i|
      #puts "Matching index=#{i} parent=#{@arr[i]} with left_child=#{left_child(i)} and right_child=#{right_child(i)}"
      if left_child(i)
        return false unless left_child(i) > @arr[i]
      end
      if right_child(i)
        return false unless right_child(i) > @arr[i]
      end
    end
    return true
  end

end


