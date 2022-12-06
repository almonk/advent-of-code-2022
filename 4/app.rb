# Create an array from a string input
# e.g. 2-4 => [2, 3, 4]
def create_range_from_string(input)
  input = input.split("-").map(&:to_i)
  return (input[0]..input[1]).to_a
end

# Check if two arrays of numbers contain each other
# e.g. [1, 2, 3, 4] and [2, 3] => true
def contains?(array1, array2)
  array2.all? { |num| array1.include?(num) }
end

# Runs `contains?` on each pair of arrays
def either_contains?(array1, array2)
  contains?(array1, array2) || contains?(array2, array1)
end

# Test an assignment pair
# e.g. 2-6, 3-4 => true
def check_assignment_pair_for_containment(assignment)
  puts "Testing #{assignment}"
  assignment = assignment.split(",")

  # Create the ranges from the input
  range1 = create_range_from_string(assignment[0])
  range2 = create_range_from_string(assignment[1])
  # Check if the ranges overlap
  puts "Result: #{either_contains?(range1, range2)}\n---"

  return either_contains?(range1, range2)
end

def run
  # Count number of containing assignments
  count = 0

  # Read the input file
  input = File.read("input.txt")

  # Split the input into an array of assignments
  assignments = input.split("\n")

  # Test each assignment
  assignments.each do |assignment|
    # Increment the count if the assignment contains
    count += 1 if check_assignment_pair_for_containment(assignment)
  end

  puts "Number of containing assignments: #{count}"
end

run
