require "typesafe_enum"

class Hand < TypesafeEnum::Base
  # Types of hands we can play
  new :ROCK
  new :PAPER
  new :SCISSORS

  # Returns the result of the hand-to-hand battle.
  def beats?(other)
    # If the other player has the same hand, it's a tie.
    return :tie if self == other

    case self
    when ROCK
      other == SCISSORS
    when PAPER
      other == ROCK
    when SCISSORS
      other == PAPER
    end
  end
end

# Maps a raw input to a hand
def map_raw_input_to_hand(hand)
  case hand
  when "A", "X"
    Hand::ROCK
  when "B", "Y"
    Hand::PAPER
  when "C", "Z"
    Hand::SCISSORS
  end
end

def score_of_hand(hand)
  case hand
  when Hand::ROCK
    1
  when Hand::PAPER
    2
  when Hand::SCISSORS
    3
  end
end

# Start reading the input...
input = "./input.txt"
rounds = File.read(input).split("\n")

# For each round split the string into an array of strings by space
rounds = rounds.map do |round|
  round.split(" ")
end

# For each round map the raw input to a hand
rounds = rounds.map do |round|
  round.map do |hand|
    hand = map_raw_input_to_hand(hand)
  end
end

# Setup our game counter
score = 0

# For each round, assign a score to each hand
rounds = rounds.map do |round|
  player1 = round[0]
  player2 = round[1]

  case player2.beats?(player1)
  when true
    score = score + score_of_hand(player2) + 6
  when false
    score = score + score_of_hand(player2) + 0
  when :tie
    score = score + score_of_hand(player2) + 3
  end
end

puts score