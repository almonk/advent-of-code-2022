enum Crane
  CrateMover9000
  CrateMover9001
end

CRANE_MODEL = Crane::CrateMover9000

class Stack
  property crates = [] of Char

  def initialize(crates : Array(Char))
    @crates = crates
  end

  # A method to pick crates from one stack and put them on another
  def move_to(stack : Stack, count : Int)
    puts "Moving #{count} crates from #{self} to #{stack}"

    if CRANE_MODEL == Crane::CrateMover9000
      stack.crates.concat(@crates.pop(count).reverse)
    else
      stack.crates.concat(@crates.pop(count))
    end
  end
end

all_stacks = [] of Stack

# Set the starting arrangement
all_stacks << Stack.new(['B', 'V', 'S', 'N', 'T', 'C', 'H', 'Q'])
all_stacks << Stack.new(['W', 'D', 'B', 'G'])
all_stacks << Stack.new(['F', 'W', 'R', 'T', 'S', 'Q', 'B'])
all_stacks << Stack.new(['L', 'G', 'W', 'S', 'Z', 'J', 'D', 'N'])
all_stacks << Stack.new(['M', 'P', 'D', 'V', 'F'])
all_stacks << Stack.new(['F', 'W', 'J'])
all_stacks << Stack.new(['L', 'N', 'Q', 'B', 'J', 'V'])
all_stacks << Stack.new(['G', 'T', 'R', 'C', 'J', 'Q', 'S', 'N'])
all_stacks << Stack.new(['J', 'S', 'Q', 'C', 'W', 'D', 'M'])

# Read the instructions
File.open("./input.txt").each_line do |line|
  # Split the line into an array
  instruction = line.split(" ")

  count = instruction[1].to_i
  from  = instruction[3].to_i
  to    = instruction[5].to_i

  # Move the crates
  all_stacks[from - 1].move_to(all_stacks[to - 1], count)
end

# Print the top of each stack as a string to get the answer
puts all_stacks.map { |stack| stack.crates.last }.join