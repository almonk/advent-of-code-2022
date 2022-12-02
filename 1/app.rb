input = "./input.txt"

# Read a file into a string
pieces = File.read(input).split("\n\n")

# For each piece map the lines to an array of integers
pieces = pieces.map do |piece|
  piece.split("\n").map(&:to_i)
end

# Sum each array within pieces
sums = pieces.map do |piece|
  piece.sum
end

# Pick the highest number piece
puts sums.max