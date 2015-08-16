# Directed edge from the 'tail' to the 'head'
class Edge
  attr_accessor :tail, :head

  def initialize(tail, head)
    @tail = tail
    @head = head
  end
end

