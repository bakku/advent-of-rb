# frozen_string_literal: true

def get_neighbour_positions(x, y, max_x, max_y)
  [].tap do |neighbour_positions|
    neighbour_positions.push([x-1, y]) if x != 0
    neighbour_positions.push([x, y-1]) if y != 0
    neighbour_positions.push([x+1, y]) if x != max_x
    neighbour_positions.push([x, y+1]) if y != max_y
  end
end

def low_point?(x, y, locations)
  get_neighbour_positions(x, y, locations[0].size - 1, locations.size - 1).all? do |pos|
    locations[pos[1]][pos[0]] > locations[y][x]
  end
end

locations = File.readlines("input.txt", chomp: true)
  .map { _1.chars.map(&:to_i) }

low_points = []

locations.each_with_index do |row, y|
  row.each_with_index do |_, x|
    low_points.push([x, y]) if low_point?(x, y, locations)
  end
end

puts low_points.reduce(0) { |sum, point| 1 + locations[point[1]][point[0]] + sum }
