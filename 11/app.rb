require "pp"

DEBUG = false

class Game
  attr_accessor :monkeys, :rounds

  def initialize
    @monkeys = []
    @rounds = 0
  end

  def play_round
    monkeys.map do |monkey|
      monkey.inspect_items
    end

    pp monkeys if DEBUG
  end
end

class Monkey
  attr_accessor :id, :items, :test_config, :operation, :total_inspect_count

  def initialize(id, items)
    @id = id
    @total_inspect_count = 0
    @items = items || []
    @test_config = test_config || nil
  end

  #
  # Inspect each item in the monkey's inventory
  #
  def inspect_items
    @items.map do |item|
      @total_inspect_count += 1

      puts "Monkey #{@id} is inspecting item #{item}" if DEBUG
      item = perform_operation(item)
      item = gets_bored(item)
      self.throw_item!(item)
    end
  end

  #
  # Performs the monkey's operation on the item
  #
  # @param [Integer] item The item to perform the operation on
  # @return [Integer] The result of the operation
  #
  def perform_operation(item)
    result = 0
    old = item
    @operation.sub!("new", "result")

    eval(@operation)

    puts "Monkey #{@id} is returning result #{result} (#{@operation})" if DEBUG

    return result
  end

  def gets_bored(item)
    return item / 3
  end

  #
  # Throw an item to another monkey
  #
  # @param [Monkey] other_monkey The monkey to throw the item to
  # @return [Array] The other monkey's new inventory
  #
  def throw_item!(item)
    # Get the test to perform on the item
    get_test = @test_config[:test].split("divisible by").last.strip.to_i

    get_true_monkey = @test_config[:if_true].split("throw to monkey").last.strip.to_i

    get_false_monkey = @test_config[:if_false].split("throw to monkey").last.strip.to_i

    # If the item is divisible by the test, throw it to the other monkey
    if item % get_test != 0
      $game.monkeys[get_false_monkey].items << item
      puts "Monkey #{@id} is throwing item #{item} to monkey #{get_false_monkey}" if DEBUG
    else
      $game.monkeys[get_true_monkey].items << item
      puts "Monkey #{@id} is throwing item #{item} to monkey #{get_true_monkey}" if DEBUG
    end

    @items = @items.drop(1)
  end
end

# Read the input from the file
input = File.read("input.txt")

# Split the input into an array of lines
input = input.split("\n")

# Create a new game
$game = Game.new

# A variable to hold the current monkey while iterating over the input
@current_monkey = nil

# Iterate over each line in the input
input.each do |line|
  line = line.strip
  # If the line is a monkey line
  if line.start_with?("Monkey")
    # Get the monkey number
    id = line.split(" ").last.to_i

    # Create a new m
    monkey = Monkey.new(id, nil)
    @current_monkey = monkey

    # Add the monkey to the game
    $game.monkeys << monkey

    # If the line is an operation line
  elsif line.start_with?("Operation")
    @current_monkey.operation = line.split(": ").last
    # If the line is a test line
  elsif line.start_with?("Test")
    @current_monkey.test_config = {
      "test": line.split(": ").last,
    }
  elsif line.start_with?("If true")
    @current_monkey.test_config[:if_true] = line.split(": ").last
  elsif line.start_with?("If false")
    @current_monkey.test_config[:if_false] = line.split(": ").last
    # If the line is an inventory line
  elsif line.start_with?("Starting")
    @current_monkey.items = line.split(": ").last.split(", ").map(&:to_i)
  end
end

20.times do
  $game.play_round
end

# Find the two monkeys with the highest total inspect count
highest = $game.monkeys.sort_by { |monkey| monkey.total_inspect_count }.last(2)
pp highest

# Output the result
puts highest[0].total_inspect_count * highest[1].total_inspect_count
