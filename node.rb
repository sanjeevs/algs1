#Node of a graph

class Node
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(other)
    return true if other.equal?(self)
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
end

