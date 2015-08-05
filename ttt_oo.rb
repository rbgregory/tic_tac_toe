# Oject Oriented Tic Tac Toe

class Player
  attr_reader :marker, :name, :board
  
  def initialize(board)
    @board = board
    @marker = 'X'
    @name = "You"
  end
  
  def pick_square(board)
    loop do
      position = get_input
      empties = board.get_empty_positions   # get the empty ones
      if empties.member?(position)
        board.set_marker(@marker, position)
        break
      else
        puts "Invalid selection."
      end
    end
  end
  
private
  def get_input
    position = 0
    loop do
      puts "Pick a square (1 - 9):"
      position = gets.chomp.to_i
      break if position
      puts "Invalid input."
    end
    position
  end
end

class Computer < Player
  attr_reader :name, :marker
  
  def initialize(board)
    super
    @marker = 'O'
    @first_move = true
    @name = 'Computer'
  end
  
  def pick_square(board)
    position = calculate_position
    board.set_marker(@marker, position)
  end
  
private

  def calculate_position
    position = board.find_two_in_a_row(@marker)
    if position == false
      #otherwise try to block opponent
      #find the opponent's marker, if they have marked
      opponent = board.find_opponent_marker(@marker)
      if opponent
        position= board.find_two_in_a_row(opponent)
      end
      
      #try strategy first
      if position == false
        if @first_move
          position = first_move_strategy
        end
        if position == false
          #no good moves, just go random
          position = board.get_empty_positions.sample
        end
      end
      position
    end
  end
  
  def first_move_strategy
    @first_move = false
    position = board.check_center
    if position == false
      position= board.get_empty_corner
    end
    position
  end


end


class Board
  
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
  CENTER = 5
  CORNER1 = 1
  CORNER2 = 3
  CORNER3 = 7
  CORNER4 = 9

  def initialize
    @board = {}
    (1..9).each {|position| @board[position] = ' '}
  end

  def draw
    system 'clear'
    puts " #{@board[1]} | #{@board[2]} | #{@board[3]} "
    puts "---+---+---"
    puts " #{@board[4]} | #{@board[5]} | #{@board[6]} "
    puts "---+---+---"
    puts " #{@board[7]} | #{@board[8]} | #{@board[9]} "
  end
  
  def find_two_in_a_row(marker)
    WINNING_LINES.each do |line|
      row= Hash[line.map{ |a_line| [a_line, @board[a_line]]}]
      position = two_in_a_row(row, marker)
      return position if position           #todo: is this right?
    end
    false
  end

  def find_opponent_marker(marker)
     (1..9).each {|position| 
      if (@board[position] != ' ') && (@board[position] != marker) 
        return @board[position] 
      end
     }
     false
  end
  
  def set_marker(marker, position)
    result = true
    empties = get_empty_positions   # get the empty ones
    if empties.member?(position)
      @board[position] = marker
    else
      result = false
    end
    result
  end
  
  def get_empty_positions
    @board.select {|_k, v| v == ' ' }.keys
  end
  
  def check_winner(player1, player2)
    WINNING_LINES.each do |line|
      if @board[line[0]] == player1.marker and @board[line[1]] == player1.marker and @board[line[2]] == player1.marker
        puts "#{line[0]}, #{line[1]}, #{line[2]}"
        return player1.name
      elsif @board[line[0]] == player2.marker and @board[line[1]] == player2.marker and @board[line[2]] == player2.marker
        puts "#{line[0]}, #{line[1]}, #{line[2]}"
        return player2.name
      end
    end
    nil
  end
  
  def check_center
    if @board[CENTER] == ' '
      CENTER
    else
      false
    end
  end
  
  def get_empty_corner
    if @board[CORNER1] == ' '
      CORNER1
    elsif @board[CORNER2] == ' '
      CORNER2
    elsif @board[CORNER3] == ' '
      CORNER3
    elsif @board[CORNER4] == ' '
      CORNER4
    else
      false
    end
  end
  
private
# checks to see if two in a row
# returns true if two mrkr in one row, plus an empty
  def two_in_a_row(row, marker)
    if row.values.count(marker) == 2
      row.select{|_k,v| v == ' '}.keys.first
    else
      false
    end
  end
  
end

class Game
  attr_accessor :player, :computer, :board
  
  def initialize
    @board = Board.new
    @player = Player.new(@board)      #give player access to the board
    @computer = Computer.new(@board)  #give computer access to the board
    @board.draw    
  end
  
  def play  
    begin
      player.pick_square(board)
      @board.draw
      winner = @board.check_winner(player, computer)
      if winner || board.get_empty_positions.empty?
        break
      end
      computer.pick_square(board)
      @board.draw
      winner = @board.check_winner(player, computer)
    end until winner || board.get_empty_positions.empty?

    if winner
      puts "#{winner} won!"
    else
      puts "It's a tie!"
    end
  end
end

Game.new.play
