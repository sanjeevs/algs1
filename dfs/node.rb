#Node of a graph

class Node
  attr_reader :name
  attr_accessor :explored
  attr_accessor :finish_time
  attr_accessor :leader

  def initialize(name)
    @name = name
    @explored = false
    @finish_time = -1
  end

  def ==(other)
    if other.instance_of?(Fixnum)
      other = Node.new(other)
    end
    name == other.name
  end

  # hash equal
  def eql?(other)
    return false unless other.instance_of?(self.class)
    name == other.name
  end

  def hash
    name.to_i
  end

  #Nodes can be lexically sorted depending on name.
  def <(other)
    name < other.name
  end

  def<=>(other)
    name <=> other.name
  end

  def is_explored?
    return explored
  end

  def is_finished?
    @finish_time >= 0
  end

end

