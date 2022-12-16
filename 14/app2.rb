# Read input from file
input = File.read("input-test.txt").strip
$rocks = []
$x_range = []
$y_range = []
$grid = []

def parse_line(line)
  # Split the line into point coordinates
  # e.g. This line contains the path of a single rock
  # 498,4 -> 498,6 -> 496,6

  # Split the line into an array of coordinates
  coordinates = line.split("->").map(&:strip)
  rock = { rock: [] }

  # For each coordinate
  coordinates.each do |coordinate|
    # Split the coordinate into x and y
    x, y = coordinate.split(",").map(&:to_i)

    # Create a new point
    point = { x: x, y: y }

    # Add the point to the rock
    rock[:rock] << point
  end

  # Add the rock to the rocks array
  $rocks << rock
end

def grid_write(x, y, char)
  $grid[y][x - $x_range.min] = char
end

def render_grid
  # Print the grid with the x and y coordinates
  spacing_dots = "." * ($x_range.max.to_s.length + 1)
  system("clear")

  puts "  #{$x_range.min}#{spacing_dots}#{$x_range.max}"
  $grid.each_with_index do |row, y|
    puts "#{y}\t#{row.join("")}"
  end
end

class Sand
  attr_accessor :x, :y
  attr_accessor :at_rest

  def initialize()
    @x = 500
    @y = 0
    @at_rest = false
  end

  def fall()
    @y += 1
  end
end

# For each line in the input file
input.each_line do |line|
  parse_line(line)
end

# Find the range of x and y coordinates
# This will be used to create the grid
$x_range = $rocks.map { |rock| rock[:rock].map { |point| point[:x] } }.flatten
$y_range = $rocks.map { |rock| rock[:rock].map { |point| point[:y] } }.flatten

# The y range minimum is always zero
$y_range = (0..$y_range.max + 1)

extra_cols = 20

$x_range = ($x_range.min - extra_cols..$x_range.max + extra_cols)

# Create the grid,,,
$grid = Array.new($y_range.count) { Array.new($x_range.count) }

# Fill the grid with air (.)
$grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    $grid[y][x] = "."
  end
end

# For each point of a rock, draw it on the grid as (#)
$rocks.each do |rock|
  rock[:rock].each do |point|
    # grid[point[:y]][point[:x]] = "#"

    grid_write(point[:x], point[:y], "#")

    # Join each rock point with the previous point
    if rock[:rock].index(point) > 0
      prev_point = rock[:rock][rock[:rock].index(point) - 1]
      x1 = prev_point[:x]
      y1 = prev_point[:y]
      x2 = point[:x]
      y2 = point[:y]
      dx = (x2 - x1).abs
      dy = (y2 - y1).abs
      sx = x1 < x2 ? 1 : -1
      sy = y1 < y2 ? 1 : -1
      err = (dx > dy ? dx : -dy) / 2

      while true
        $grid[y1][x1 - $x_range.min] = "#"
        break if x1 == x2 && y1 == y2
        e2 = err
        if e2 > -dx
          err -= dy
          x1 += sx
        end
        if e2 < dy
          err += dx
          y1 += sy
        end
      end
    end
  end
end

# Add a floor to the grid
$grid << Array.new($x_range.count, "#")

# Place the sand entry point
grid_write(500, 0, "+")

render_grid

# Keep track of the sand
sands = []

sand_limit = 10000000000000000000000000
sand_count = 0

# If there's no sand, create a new sand object
while true
  sands << Sand.new if sands.empty? && sand_count <= sand_limit

  # For each sand object
  sands.each do |sand|
    if !sand.at_rest
      # Check if sand is out of bounds

      if $grid[sand.y + 1][sand.x - $x_range.min] == "."
        # The sand is falling
        sand.fall

        # Draw the sand on the grid
        grid_write(sand.x, sand.y, "o")

        # Remove the previous sand position from the grid
        grid_write(sand.x, sand.y - 1, ".")
      elsif $grid[sand.y + 1][sand.x - $x_range.min] == "o" || $grid[sand.y + 1][sand.x - $x_range.min] == "#"
        # Is there space to the left and down?
        if $grid[sand.y + 1][sand.x - 1 - $x_range.min] == "." && $grid[sand.y + 1][sand.x - 1 - $x_range.min] != "#"
          # Move the sand to the left
          sand.x -= 1
          sand.fall

          grid_write(sand.x, sand.y, "o")
          grid_write(sand.x + 1, sand.y - 1, ".")
        elsif $grid[sand.y + 1][sand.x + 1 - $x_range.min] == "." && $grid[sand.y + 1][sand.x + 1 - $x_range.min] != "#"
          # Move the sand to the right
          sand.x += 1
          sand.fall

          grid_write(sand.x, sand.y, "o")
          grid_write(sand.x - 1, sand.y - 1, ".")
        else
          # There's no where to go, the sand is at rest
          sand.at_rest = true

          return if sand.y == 0 and sand.x == 500

          sands.delete(sand)
          sand_count += 1
        end
      else
        sand.at_rest = true

        return if sand.y == 0 and sand.x == 500

        sands.delete(sand)
        sand_count += 1
      end

      # Render the grid
      render_grid
      puts "Sand count: #{sand_count + 1}"
    end
  end
end
