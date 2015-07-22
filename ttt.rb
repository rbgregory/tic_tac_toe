#tic tac toe
require 'pry'

WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

def initialize_board
  b = {}
  (1..9).each {|position| b[position] = ' '}
  b
end

def draw_board(b)
  system 'clear'
  puts " #{b[1]} | #{b[2]} | #{b[3]} "
  puts "---+---+---"
  puts " #{b[4]} | #{b[5]} | #{b[6]} "
  puts "---+---+---"
  puts " #{b[7]} | #{b[8]} | #{b[9]} "
end

def player_picks_square(b)
  loop do
    puts "Pick a square (1 - 9):"
    position = gets.chomp.to_i
    empties = empty_positions(b)    # get the empty ones
    if( empties.member?(position) )
      b[position] = 'X'
      break
    else
      draw_board(b)
      if(position == 0)
        puts "Invalid input."
      else
        puts "That spot is already taken."
      end
    end
  end
end

def empty_positions(b)
  b.select {|k, v| v == ' ' }.keys
end

def find_two(b, mrkr)
  WINNING_LINES.each do |line|
    h = Hash[ line.map { |x| [x, b[x]]} ]
    position = two_in_a_row(h,mrkr)
    return position if( position ) 
  end
  return nil
end

# checks to see if two in a row
# returns true if two mrkr in one row, plus an empty
def two_in_a_row(hsh, mrkr)
  if hsh.values.count(mrkr) == 2
    hsh.select{|k,v| v == ' '}.keys.first
  else
    false
  end
end

def computer_picks_square(b)
  #strategy to find two in a row
  #first try to find two x's in a row
  position = find_two(b, 'O')
  if(position)
    # Win if you can first
    b[position]= 'O'
    return
  else
    puts "now try X"
    #otherwise try to block X
    position= find_two(b, 'X')
    if(position)
      #go for the kill!
      b[position]= 'O'
      return
    end
  end
  
  position = empty_positions(b).sample
  b[position] = 'O'
end

def check_winner(b)
  WINNING_LINES.each do |line|
    if b[line[0]] == 'X' and b[line[1]] == 'X' and b[line[2]] == 'X'
      puts "#{line[0]}, #{line[1]}, #{line[2]}"
      return 'Player'
    elsif b[line[0]] == 'O' and b[line[1]] == 'O' and b[line[2]] == 'O'
      puts "#{line[0]}, #{line[1]}, #{line[2]}"
      return 'Computer'
    end
  end
  return nil
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

