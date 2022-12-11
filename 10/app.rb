class CPU
  attr_accessor :cycle
  attr_accessor :registers
  attr_accessor :screen

  def initialize
    @cycle = 0
    @registers = { x: 1, signal: [] }

    # Create a screen
    @screen = Screen.new
  end

  def tick
    # Get the normalized position of the current cycle
    position = @cycle % 40

    # Draw a pixel if the X register is plus or minus 1 of the current cycle
    @screen.draw_pixel(@cycle) if (position - 1..position + 1).include?(@registers[:x])

    # Tick the cycle
    @cycle += 1

    # On the 20th cycle, 60th cycle, 100th cycle, etc. dump the registers
    puts dump_registers if @cycle % 40 == 20
  end

  def addx(n)
    tick
    tick
    @registers[:x] += n
  end

  def noop
    tick
  end

  private

  def dump_registers
    puts "Cycle: #{@cycle}"
    puts "Registers: #{@registers}"
    puts "Signal strength: #{signal_strength}"
    puts "Screen:"
    @screen.draw
  end

  def signal_strength
    # Store the signal strength in the registers
    @registers[:signal] << @registers[:x] * @cycle

    # Multiply the signal strength by the cycle number
    return @registers[:x] * @cycle
  end
end

class Screen
  # The screen is a 2D array of pixels
  attr_accessor :pixels

  def initialize
    @pixels = Array.new(6) { Array.new(40) }
  end

  def draw_pixel(position)
    # Wrap the position around the screen
    # So that positions 0-39 are on the first row, 40-79 are on the second row, etc.

    case position
    when 0..39
      row = 0
      column = position
    when 40..79
      row = 1
      column = position - 40
    when 80..119
      row = 2
      column = position - 80
    when 120..159
      row = 3
      column = position - 120
    when 160..199
      row = 4
      column = position - 160
    when 200..239
      row = 5
      column = position - 200
    end

    # Draw the pixel
    @pixels[row][column] = 1
  end

  def draw
    # Draw the screen
    @pixels.each do |row|
      row.each do |pixel|
        print pixel == 1 ? "🟥" : "⬛"
      end
      puts
    end
    puts "-" * 40
  end
end

# Parse input
instructions = File.readlines("input.txt").map do |line|
  line.strip.split(" ")
end

# Create CPU
cpu = CPU.new

# Execute instructions
instructions.each do |instruction|
  case instruction[0]
  when "addx"
    cpu.addx(instruction[1].to_i)
  when "noop"
    cpu.noop
  end
end

puts "Final signal strength: #{cpu.registers[:signal].inject(:+)}"

# Draw the final screen
cpu.screen.draw
