class Board
  def initialize(grid = [["_","_","_"],["_","_","_"],["_","_","_"]])
    @grid = grid
  end

  def grid
    @grid.map{ |row| row.dup}
  end

  def avail_moves
    avail=[]
    (0..2).each do |row_i|
      (0..2).each do |col_i|
        avail << [row_i, col_i] if @grid[row_i][col_i] == "_"
      end
    end
    avail
  end

  def move(coordinate,symbol)
    if @grid[coordinate[0]][coordinate[1]] == "_"
      @grid[coordinate[0]][coordinate[1]] = symbol
    else
      return false
    end
  end

  def winner
    return rows if rows
    return columns if columns
    return diagonals if diagonals
    nil
  end

  def board_full?
    @grid.each do |row|
      return false if row.include?("_")
    end
    true
  end

  def print_board
    puts "-------------"
    @grid.each do |row|
      row.each {|space| print "| #{space} "}
      print "|\n-------------"
      puts
    end
  end

  private

  def rows
    @grid.each do |row|
      return "X" if row.count("X") == 3
      return "O" if row.count("O") == 3
    end
    nil
  end

  def columns
    (0..2).each do |col_i|
      num_x = 0
      num_o = 0
      (0..2).each do |row_i|
        num_x += 1 if @grid[row_i][col_i] == "X"
        num_o += 1 if @grid[row_i][col_i] == "O"
      end

      return "X" if num_x == 3
      return "O" if num_o == 3
    end

    nil
  end

  def diagonals
    if @grid[0][0] == @grid[1][1] && @grid[1][1] == @grid[2][2]
      if @grid[2][2]=="X"
        return "X"
      elsif @grid[2][2]=="O"
        return "O"
      end
    end
    if @grid[0][2] == @grid[1][1] && @grid[1][1] == @grid[2][0]
      if @grid[2][0]=="X"
        return "X"
      elsif @grid[2][0]=="O"
        return "O"
      end
    end
    nil
  end

end