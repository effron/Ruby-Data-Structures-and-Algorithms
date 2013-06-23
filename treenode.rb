class TreeNode

  attr_accessor :parent, :value
  attr_reader :children

  def initialize( parent = nil, value = nil )
    @parent = parent
    @value = value
    @children = []
  end

  def make_child(child_value)
    @children << self.class.new(parent = self, value = child_value)
  end

  def make_children(child_values)
    child_values.each do |child_value|
      self.make_child(child_value)
    end
  end

  def children_values
    self.children.map{|child| child.value}
  end

  def path
    current_parent = self.parent
    current_path = [self.value]
    until current_parent.nil?
      current_path << current_parent.value
      current_parent = current_parent.parent
    end

    current_path.reverse

  end

  def inspect
    "parent: #{self.parent}, value: #{self.value}, children: #{!self.children.empty?}"
  end

  def dfs(target = nil,&block)
    if block_given?
      return self if block.call(self.value)
    end
    return self if self.value == target
    found = nil

    self.children.each do |child|
      found = child.dfs(target, &block)
      break if found
    end

    found
  end

  def bfs(target = nil)
    broad_array = [self]

    until broad_array.empty?
      check = broad_array.shift

      if block_given?
        return check if yield(check.value)
      end

      return check if check.value == target

      unless check.children.empty?
        check.children.each do |child|
          broad_array << child
        end
      end

    end

    nil
  end
  
  def count
    1 + self.children.map(&:count).sum
  end
  
end

if $PROGRAM_NAME == __FILE__
  a = TreeNode.new(nil, 1)
  a.make_child(2)
  a.make_child(3)
  a.make_child(4)
  a.children[0].make_child(5)
  a.children[1].make_children([6,7,8])
  a.children[2].make_children([9,10,11,12])
  p a.children[1].children[1].path
end