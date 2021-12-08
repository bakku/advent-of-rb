# frozen_string_literal: true

def process_day(lanternfish)
  new_fish = []

  modified_lanternfish = lanternfish.map do |fish|
    next fish - 1 unless fish.zero?

    new_fish.push(8)
    6
  end

  modified_lanternfish.concat(new_fish)
end

def process_days(initial_lanternfish, days)
  (0...days).to_a.reduce(initial_lanternfish) { process_day(_1) }
end

puts File.read("./input.txt")
       .strip
       .split(",")
       .map(&:to_i)
       .then { |lanternfish| process_days(lanternfish, 80) }
       .count
