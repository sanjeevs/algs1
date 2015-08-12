# A unidirected edge
# edges are the same if they have the nodes in any order.
# To keep it simple we store the less than 'node' as the first member.
class Edge
  attr_accessor :n1, :n2

  # Initialize an edge. Self loops are not allowed.
  def initialize(n1, n2)
    raise "No self loops allowed" if n1 == n2
    @n1 = (n1 < n2) ? n1 : n2
    @n2 = (n1 < n2) ? n2 : n1 
  end

  #Return the node not matching the given node.
  def from(node)
    if node == n2
      return n1 
    elsif node == n1
      return n2 
    else
      raise ArgumentError, "No matching node at both ends of the edge"
    end
  end

  #Edges are equal if they have the same end points in any order
  def ==(other)
    n1 == other.n1 and n2 == other.n2
  end

  def eql?(other)
    return self == other
  end

  def hash
    return n1.hash ^ n2.hash
  end

  def self_loop?
    n1 == n2
  end
end
