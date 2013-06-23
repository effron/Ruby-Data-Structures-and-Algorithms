require "./treenode"

class KnightPathFinder
  POSSIBLE_MOVES=[[1,2],[1,-2],[-1,2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
  BOARD = 7

  def self.new_move_positions(coords)
    x, y = coords

    new_moves = []

    POSSIBLE_MOVES.each do |up,over|
      new_moves << [x + up, y + over] if (0..BOARD).include?(x + up) && (0..BOARD).include?(y + over)
    end

    new_moves
  end

  attr_accessor :move_tree

  def initialize(start_pos)
    @move_tree = TreeNode.new(nil, start_pos)
    build_move_tree(@move_tree)
  end

  def find_path(target_pos)
    @move_tree.dfs(target_pos).path
  end

  private

  def build_move_tree(parent)
    self.class.new_move_positions(parent.value).each do |pos|
      parent.make_child(pos) unless @move_tree.bfs(pos)
    end

    unless parent.children.empty?
      parent.children.each do |child|
        build_move_tree(child)
      end
    end
  end

end


a = KnightPathFinder.new([0,0])
p a.find_path([3,2])