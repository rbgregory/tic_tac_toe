#tic tac toe
require 'pry'

WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

def initialize_board
  board = {}
  (1..9).each {|position| board[position] = ' '}
  board
end

def draw_board(board)
  system 'clear'
  puts " #{board[1]} | #{board[2]} | #{board[3]} "
  puts "---+---+---"
  puts " #{board[4]} | #{board[5]} | #{board[6]} "
  puts "---+---+---"
  puts " #{board[7]} | #{board[8]} | #{board[9]} "
end

def player_picks_square(board)
  loop do
    puts "Pick a square (1 - 9):"
    position = gets.chomp.to_i
    empties = empty_positions(board)    # get the empty ones
    if empties.member?(position)
      board[position] = 'X'
      break
    else
      draw_board(board)
      if position == 0
        puts "Invalid input."
      else
        puts "That spot is already taken."
      end
    end
  end
end

def empty_positions(board)
  board.select {|_k, v| v == ' ' }.keys
end

def find_two_in_a_row(board, marker)
  WINNING_LINES.each do |line|
    row= Hash[line.map{ |a_line| [a_line, board[a_line]]}]
    position = two_in_a_row(row, marker)
    return position if position
  end
  false
end

# checks to see if two in a row
# returns true if two mrkr in one row, plus an empty
def two_in_a_row(row, marker)
  if row.values.count(marker) == 2
    row.select{|_k,v| v == ' '}.keys.first
  else
    false
  end
end

def computer_picks_square(board)
  #first try to find two O's in a row to win
  position = find_two_in_a_row(board, 'O')
  if position
    puts "computer found two O in a row at #{position}"
  end
  if position == false
    #otherwise try to block X
    position= find_two_in_a_row(board, 'X')
    puts "computer found to X in a row at #{position}"
    if position == false
      puts "computer did not find 2 X in a row"
      position = empty_positions(board).sample
    end
  end
  board[position] = 'O'
end

def check_winner(board)
  WINNING_LINES.each do |line|
    if board[line[0]] == 'X' and board[line[1]] == 'X' and board[line[2]] == 'X'
      puts "#{line[0]}, #{line[1]}, #{line[2]}"
      return 'Player'
    elsif board[line[0]] == 'O' and board[line[1]] == 'O' and board[line[2]] == 'O'
      puts "#{line[0]}, #{line[1]}, #{line[2]}"
      return 'Computer'
    end
  end
  nil
end

board = initialize_board
draw_board(board)

begin
  player_picks_square(board)
  computer_picks_square(board)
  draw_board(board)
  winner = check_winner(board)
end until winner || empty_positions(board).empty?

if winner
  puts "#{winner} won!"
else
  puts "It's a tie!"
end
