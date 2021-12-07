# frozen_string_literal: true

def calculate_fuel_for_position(positions, target_position)
  positions.reduce(0) do |sum, pos|
    offset = (pos - target_position).abs
    next sum if offset.zero?

    fuel_usage = (1..offset).to_a.inject(:+)

    sum + fuel_usage
  end
end

crab_positions = File.read("./07_input_02.txt")
  .strip
  .split(",")
  .map(&:to_i)

min_target = 0
max_target = crab_positions.max * 2

puts (min_target..max_target).map { calculate_fuel_for_position(crab_positions, _1) }
  .min
