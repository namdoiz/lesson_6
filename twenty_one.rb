def prompt(msg)
  puts "=> #{msg}"
end

def player_over21?(cds)
  player_cards_sum = cds.map do |cards|
    cards[1]
  end
  player_cards_sum = player_cards_sum.sum
  player_cards_sum > 21
end

def dealer_over21?(cds)
  dealer_cards_sum = cds.map do |cards|
    cards[1]
  end
  dealer_cards_sum = dealer_cards_sum.sum
  dealer_cards_sum > 21
end

# creating the cards

cards1 = {}
cards2 = {}
cards3 = {}
cards4 = {}
pips = %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)

suits = %w(Clubs Diamond Hearts Spades)

pips.each do |pip|
  cards1[pip] = suits[0]
end

pips.each do |pip|
  cards2[pip] = suits[1]
end

pips.each do |pip|
  cards3[pip] = suits[2]
end

pips.each do |pip|
  cards4[pip] = suits[3]
end

cards1 = cards1.to_a.map do |arr|
  arr.join(' of ')
end

cards2 = cards2.to_a.map do |arr|
  arr.join(' of ')
end

cards3 = cards3.to_a.map do |arr|
  arr.join(' of ')
end

cards4 = cards4.to_a.map do |arr|
  arr.join(' of ')
end

cards = []
cards << cards1
cards << cards2
cards << cards3
cards << cards4
cards.flatten!

# assigning values to the cards (only card not assigned value is the ace)

value = {}
cards.each do |card|
  value[card] = card[0..1].to_i
end
cards.each do |card|
  if card.start_with?("Ja", "Qu", "Ki")
    value[card] = 10
  end
end
cards.each do |card|
  if card.start_with?("Ace")
    value[card] = 11
  end
end

cards = value

player_cards = []
player_cards << cards.to_a.sample
player_cards << cards.to_a.sample

dealer_cards = []
dealer_cards << cards.to_a.sample
dealer_cards << cards.to_a.sample

# assigning values to ace cards if any:

def card_values(cds)
  player_cards_values = []
  cds.each do |arr|
    player_cards_values << arr[1]
  end
  player_cards_values_sum = player_cards_values.sum
  ace_index = player_cards_values.index(1)
  if player_cards_values_sum > 21 && player_cards_values.count(11) > 0
    player_cards_values[ace_index] = 1
    player_cards_values_sum = player_cards_values.sum
    if player_cards_values_sum > 21
      player_cards_values[ace_index] = 1
      player_cards_values_sum = player_cards_values.sum
    end
  end
  player_cards_values_sum
end

def player_cards_display(cds)
  cards_display = []
  cds.each do |arr|
    cards_display << arr[0]
  end
  cards_display.flatten!
  cards_display
end

def dealer_cards_display(cds)
  cards_display = []
  cds.each do |arr|
    cards_display << arr[0]
  end
  cards_display.flatten!
  cards_display
end

# gameplay
system "clear"
prompt "Welcome to TWENTY 1"
prompt "Player, your cards are : #{player_cards[0][0]}, #{player_cards[1][0]}"
prompt "Dealer, your cards are : #{dealer_cards[0][0]}, #{dealer_cards[1][0]}"
puts " "
puts " "
loop do
  prompt "Player turn: hit or stay? (1 -> Hit) (2 -> Stay)"
  player_answer = gets.chomp
  if player_answer == '1' && !player_over21?(player_cards)
    player_cards << cards.to_a.sample
    if card_values(player_cards) > 21
      prompt "BUST! Dealer wins"
      break
    else
      prompt "Player your cards are #{player_cards_display(player_cards)}"
    end
  elsif player_answer == '2'
    break
  elsif player_over21?(player_cards)
    prompt "BUST! Dealer wins"
    break
  end
end
if !player_over21?(player_cards)
  loop do
    prompt "Dealer turn: hit or stay? (1 -> Hit) (2 -> Stay)"
    prompt "Dealer must hit until total is at least 17!"
    dealer_answer = gets.chomp
    if dealer_answer == '1'
      dealer_cards << cards.to_a.sample
      if card_values(dealer_cards) > 21
        prompt "BUST! Player wins"
        break
      else
        prompt "Dealer your cards are #{dealer_cards_display(dealer_cards)}"
      end
    elsif dealer_answer == '2'
      break
    elsif dealer_over21?(dealer_cards)
      prompt "BUST! Player wins"
      break
    end
  end
end

prompt "Comparing cards..."
puts " "
prompt "Player has #{player_cards_display(player_cards)} and the sum of values is #{card_values(player_cards)}"
puts " "
prompt "Dealer has #{dealer_cards_display(dealer_cards)} and the sum of values is #{card_values(dealer_cards)}"
puts " "
if card_values(dealer_cards) > card_values(player_cards)
  prompt "DEALER wins!"
elsif card_values(dealer_cards) < card_values(player_cards)
  prompt "PLAYER wins!"
elsif card_values(dealer_cards) == card_values(player_cards)
  prompt "DRAW"
end
puts " "
puts " "
puts "Thanks for playing TWENTY 1!"
puts "Goodbye!"
