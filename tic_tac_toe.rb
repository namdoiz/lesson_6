require 'pry'
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def joinor(arr, sep = ', ', for_last_ele = 'or')
  last_one = arr.pop
  str = arr.join(sep)
  puts "#{str.concat(" #{for_last_ele}", " #{last_one}")}"
end

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "First to Five"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |   #{brd[3]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |   #{brd[6]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |   #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board # board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt("Choose a square (#{joinor(empty_squares(brd))}):")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(brd)
  ind = []
  ind = WINNING_LINES.select do |lines|
    brd.values_at(*lines).count(PLAYER_MARKER) == 2
  end
  ind = ind.flatten
  value = ind.index do |x|
    brd[x] == ' '
  end
  brd[ind[value]] = COMPUTER_MARKER
end

def computer_offence(brd)
  ind = []
  ind = WINNING_LINES.select do |lines|
    brd.values_at(*lines).count(COMPUTER_MARKER) == 2 &&
    brd.values_at(*lines).count(INITIAL_MARKER) == 1
  end
  ind = ind.flatten
  value = ind.index do |x|
    brd[x] == ' '
  end
  brd[ind[value]] = COMPUTER_MARKER
end

def computer_chance?(brd)
  arr = []
  arr << WINNING_LINES.select do |lines|
    brd.values_at(*lines).count(COMPUTER_MARKER) == 2 &&
    brd.values_at(*lines).count(INITIAL_MARKER) == 1
  end
  arr.flatten!
  if arr.empty?
    return false
  else
    return true
  end
end

def computer_places_piece!(brd)
  if computer_chance?(brd)
    computer_offence(brd)
  elsif immediate_threat?(brd)
    find_at_risk_square(brd)
  elsif brd[5] == ' '
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
# if brd[line[0]]  == PLAYER_MARKER &&
#    brd[line[1]]  == PLAYER_MARKER &&
#    brd[line[2]]  == PLAYER_MARKER
#   return 'Player'
# elsif brd[line[0]]  == COMPUTER_MARKER &&
#       brd[line[1]]  == COMPUTER_MARKER &&
#       brd[line[2]]  == COMPUTER_MARKER
#   return 'Computer'
# end
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def immediate_threat?(brd)
  arr = []
  arr << WINNING_LINES.select do |lines|
    brd.values_at(*lines).count(PLAYER_MARKER) == 2 &&
    brd.values_at(*lines).count(INITIAL_MARKER) == 1
  end
  arr.flatten!
  if arr.empty?
    return false
  else
    return true
  end
end

computer_wins = 0
player_wins = 0

loop do
  board = initialize_board
  prompt "Welcome to TIC TAC TOE!"
  prompt "Loading..."
  prompt "Do you want to decide who goes first or you want computer to decide?"
  prompt "'1': I'll decide, '2': Let computer decide "
  who_goes_first = gets.chomp
  if who_goes_first == '1'
    prompt "Do you want to go first?"
    prompt "1 = 'yes'"
    prompt "2 = 'no'"

    go_first = gets.chomp
    if go_first == '1'
      loop do
        display_board(board)
      
        player_places_piece!(board)
        break if someone_won?(board) || board_full?(board)

        computer_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      end
    elsif go_first == '2'
      loop do
        computer_places_piece!(board)

        display_board(board)
        break if someone_won?(board) || board_full?(board)

        player_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      end
    end
  elsif who_goes_first == '2'
    go_first = ['1', '2'].sample
    if go_first == '1'
      loop do
        display_board(board)
      
        player_places_piece!(board)
        break if someone_won?(board) || board_full?(board)

        computer_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      end
    elsif go_first == '2'
      loop do
        computer_places_piece!(board)

        display_board(board)
        break if someone_won?(board) || board_full?(board)

        player_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      end
    end
  end

  display_board(board)

  if someone_won?(board)
    if detect_winner(board).start_with?('P')
      player_wins += 1
      if player_wins == 5
        prompt "Play again? (y or n)"
        answer = gets.chomp
        break unless answer.downcase.start_with?('y')
      else
        next
      end
    elsif detect_winner(board).start_with?('C')
      computer_wins += 1
      if computer_wins == 5
        prompt "Play again? (y or n)"
        answer = gets.chomp
        break unless answer.downcase.start_with?('y')
      else
        next
      end
    end
  end
end
prompt "Player won #{player_wins} times."
prompt "Computer won #{computer_wins} times."
prompt 'Thanks for playing TIC TAC TOE! Goodbye.'
