require "./treenode"
require "./tic_tac_toe_board"

class TicTacToe
  def initialize(player_x = HumanPlayer.new("X"), player_o = ComputerPlayer.new("O"))
    @board = Board.new
    @player_x = player_x
    @player_o = player_o
  end

  def play
    until @board.winner
      @board.move(@player_x.make_move(@board), "X")
      break if @board.winner || @board.board_full?
      @board.print_board
      @board.move(@player_o.make_move(@board), "O")
      break if @board.winner || @board.board_full?
      @board.print_board
    end
    puts "#{@board.winner} is winner!" unless @board.board_full?
    @board.print_board
  end

end

class HumanPlayer
  attr_reader :symbol
  def initialize(symbol = "X")
    @symbol = symbol
  end

  def make_move(board)
    print "Enter the coordinate where you'd like to play: "
    coordinate = gets.chomp
    coordinate = coordinate.split(",")
    coordinate.map! {|coord| coord.to_i}
  end
end

class ComputerPlayer
  EMPTY_GRID = [["_","_","_"],["_","_","_"],["_","_","_"]]
  attr_reader :symbol, :game_tree
  def initialize(symbol = "O")
    @symbol = symbol
    @symbol == "O" ? @opponent_symbol = "X" : @opponent_symbol = "O"
    @game_tree = TreeNode.new(nil, {:grid => EMPTY_GRID, :next_move => @symbol})
    build_move_tree(@game_tree)
  end

  def make_move(board)
    find_best_move(board)
  end

#  private

  def build_move_tree(parent)
    board = Board.new(parent.value[:grid])
    current_symbol = parent.value[:next_move]
    current_symbol == "X" ? next_move = "O" : next_move = "X"

    unless board.winner
      board.avail_moves.each do |coords|
        child_value = {:next_move => next_move}
        child_value[:grid] = check_move(board,coords, next_move)

        parent.make_child(child_value)
      end
    end
    #recurse
    unless parent.children.empty?
      parent.children.each do |child|
        build_move_tree(child)
      end
    end
  end

  def check_move(board, move ,symbol)
    x,y = move
    dup_grid = board.grid
    dup_grid[x][y] = symbol
    dup_grid
  end

  def is_winning_node?(node, player)

    return_value = true
    board = Board.new(node.value[:grid])
    if node.children.empty?
      return board.winner == player
    elsif guaranteed_winner?(board,player)
      return true
    end

    node.children.each do |child|
      value = is_winning_node?(child,player)
      return_value = return_value && value
    end

    return_value
  end

  def winning_move_available?(board, symbol)
    board.avail_moves.each do |move|
      win_board = Board.new(check_move(board,move,symbol))
      return true if win_board.winner
    end
    false
  end

  def guaranteed_winner?(board,symbol)
    winning_moves(board,symbol).length >= 2
  end

  def winning_moves(board,symbol)
    moves = []
    board.avail_moves.each do |move|
      win_board = Board.new(check_move(board,move,symbol))
      moves << move if win_board.winner
    end
    moves
  end

  def find_best_move(board)
    node = @game_tree.dfs({:grid => board, :next_move => @opponent_symbol})
    node.bfs do |child|
      is_winning_node?(child)
    end
  end

  #Debugging
  def return_node(board)
    @game_tree.dfs{|node| node[:grid]==board}
  end

end

# game = TicTacToe.new(player_x = HumanPlayer.new("X"), player_o = HumanPlayer.new("O"))
# game.play
fake_node = [["_","_","O"],["_","X","_"],["X","O","_"]]
a = ComputerPlayer.new("X")
c = a.return_node(fake_node)
p c
p a.is_winning_node?(c, "X")