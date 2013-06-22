class BinaryTreeNode

  attr_accessor :parent, :value
  attr_reader :left, :right

  def initialize( parent = nil, value = nil )
    @parent = parent
    @value = value
  end

  def left=(child_value)
    if @left
      @left.parent = nil
    end
    @left = self.class.new(parent = self, value = child_value)
  end

  def right=(child_value)
    if @right
      @left.parent = nil
    end
    @right = self.class.new(parent = self, value = child_value)
  end

  def inspect
    "parent: #{self.parent}, value: #{self.value}, left: #{self.left}, right: #{self.right}"
  end

  def dfs(target)
    return self if self.value == target

    found = left.dfs(target) unless self.left == nil
    if found
      return found
    end
    return nil if self.right == nil
    right.dfs(target)
  end

  def bfs(target)
    broad_array = [self]

    until broad_array.empty?
      check = broad_array.shift

      return check if check.value == target
      broad_array << check.left if check.left
      broad_array << check.right if check.right

    end
  end
end

$a = BinaryTreeNode.new(nil, 1)
$a.left = 2
$a.left.left = 4
$a.left.right = 5
$a.right = 3
$a.right.right = 6
$a.right.right.left = 7
$a.right.right.right = 8
