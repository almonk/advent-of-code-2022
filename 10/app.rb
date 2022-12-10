class CPU
  attr_accessor :cycle
  attr_accessor :registers

  def initialize
    @cycle = 0
    @registers = { x: 1, signal: [] }
  end

  def tick
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
  end

  def signal_strength
    # Store the signal strength in the registers
    @registers[:signal] << @registers[:x] * @cycle

    # Multiply the signal strength by the cycle number
    return @registers[:x] * @cycle
  end
end

# Parse input
instructions = File.readlines("input-test.txt").map do |line|
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
