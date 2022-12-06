# typed: true

# Model an object that is a rucksack with many compartments
class Rucksack
  # The compartments of the rucksack
  attr_accessor :compartments

  def initialize(compartments)
    @compartments = compartments
  end

  # Find unique characters that exist in all compartments
  def common_contents
    @compartments.map do |compartment|
      compartment.chars.uniq
    end
      .reduce(:&)
  end
end

# Function which splits a string in half and returns the two halves
def split_string_in_half(string)
  string_length = string.length
  half = string_length / 2
  [string[0..half - 1], string[half..string_length]]
end

def priority_score_for_character(character)
  # For letters between a-z, return the score
  if character =~ /[a-z]/
    character.ord - 96
    # For letters between A-Z, return the score
  elsif character =~ /[A-Z]/
    character.ord - 38
    # For all other characters, return 0
  else
    0
  end
end

# Start reading the input...
input = "./input.txt"
input_array = File.read(input).split("\n")

# Read every 3 lines in the input_array into an array
sliced_input_array = input_array.each_slice(3).to_a

score = 0

sliced_input_array.each do |slice|
  rucksack = Rucksack.new(slice)

  rucksack.common_contents.each do |character|
    score += priority_score_for_character(character)
  end
end

puts score
