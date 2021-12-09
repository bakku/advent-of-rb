# frozen_string_literal: true

require 'byebug'

Point = Struct.new(:x, :y) do
  def inspect
    "{x: #{x}, y: #{y}}"
  end
end

def get_neighbour_positions(p, max_x, max_y)
  [].tap do |neighbour_positions|
    neighbour_positions.push(Point.new(p.x - 1, p.y)) if p.x > 0
    neighbour_positions.push(Point.new(p.x, p.y - 1)) if p.y > 0
    neighbour_positions.push(Point.new(p.x + 1, p.y)) if p.x < max_x
    neighbour_positions.push(Point.new(p.x, p.y + 1)) if p.y < max_y
  end
end

def low_point?(p, locations)
  get_neighbour_positions(p, locations[0].size - 1, locations.size - 1).all? do |point|
    locations[point.y][point.x] > locations[p.y][p.x]
  end
end

def calculate_basin_size(start, locations)
  queue = [start]
  basin = []

  max_x = locations[0].size - 1
  max_y = locations.size - 1

  until queue.size.zero?
    next_point = queue.shift
    basin.push(next_point)

    get_neighbour_positions(next_point, max_x, max_y).each do |p|
      queue.push(p) if locations[p.y][p.x] < 9 && !basin.include?(p) && !queue.include?(p)
    end
  end

  basin
end

locations = File.readlines("./input.txt", chomp: true)
  .map { _1.chars.map(&:to_i) }

low_points = []

locations.each_with_index do |row, y|
  row.each_with_index do |_, x|
    p = Point.new(x, y)
    low_points.push(p) if low_point?(p, locations)
  end
end

puts low_points.map { |low_point| calculate_basin_size(low_point, locations) }
       .map(&:size)
       .sort
       .reverse[0..2]
       .reduce(1) { |prod, n| prod * n }
