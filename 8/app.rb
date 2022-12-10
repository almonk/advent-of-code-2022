# Given a position in a 2d array, return the value at that position
def get_value(x, y)
  # Get the row
  row = @input[y]

  # Get the value at the given position
  row[x].to_i
end

# From a given position, return all the values to the left, right, up, and down all the way to the edge of the array
def get_neighbors(x, y)
  # Get the row
  row = @input[y]

  # Get the values to the left of the given position
  left = row[0..x - 1].to_i

  # Get the values to the right of the given position
  right = row[x + 1..-1].to_i

  # Get the values up the given position
  up = column = @input[0..y - 1].map { |row| row[x].to_i }.join.to_i

  # Get the values down from the given position
  down = column = @input[y + 1..-1].map { |row| row[x].to_i }.join.to_i

  # Return the values
  return [
           split_number(up).reverse,
           split_number(left).reverse,
           split_number(down),
           split_number(right),
         ]
end

# Split a number into an array of its digits
def split_number(number)
  number.to_s.split("").map(&:to_i)
end

# A tree is visible is any of the neighbors contain all lower values than the value
def is_visible?(value, neighbors)
  answers = []
  neighbors.each do |neighbor|
    answers << false if neighbor.max >= value
    answers << true if neighbor.max < value
  end

  return answers.include?(true)
end

# For each neighbor of a given position, iterate through the values and count how many are lower or equal to the original value
def count_visible(value, neighbors)
  answers = []
  neighbors.each do |neighbor|
    count = 0

    neighbor.each do |n|
      count += 1
      break if n >= value
    end

    answers << count
  end

  return answers
end

# Given the values from count_visible, return the multiplied sum of the values
def scenic_score(values)
  values.compact!
  values.inject(:*)
end

@input = File.read("input.txt")

# Count the number of columns before the first newline
columns = @input.index("\n")

# Strip whitespace from input
@input = @input.gsub(/\s+/, "")

# Split input into an array of arrays of 5 characters
@input = @input.scan(/.{1,#{columns}}/)

puts @input

count = 0
highest_scenic_score = 0

# For each item in the input array, check if it is the lowest in its row and column
@input.each_with_index do |row, y|
  row.each_char.with_index do |char, x|
    value = get_value(x, y)
    neighbors = get_neighbors(x, y)

    # Always count the border trees
    if x == 0 || y == 0 || x == row.length - 1 || y == @input.length - 1
      count += 1
    else
      count += 1 if is_visible?(value, neighbors)
      puts "#{value}(x #{x}, y #{y}) #{count_visible(value, neighbors)} Scenic score: #{scenic_score(count_visible(value, neighbors))}"
      highest_scenic_score = scenic_score(count_visible(value, neighbors)) if scenic_score(count_visible(value, neighbors)) > highest_scenic_score
    end
  end
end

puts "There are #{count} visible trees."
puts "The highest scenic score is #{highest_scenic_score}."
