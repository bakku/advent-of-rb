# frozen_string_literal: true

def process_day(lanternfish)
  lanternfish.dup.tap do |l|
    new_fish = l.shift

    l.push(new_fish)
    l[6] += new_fish
  end
end

def process_days(initial_lanternfish, days)
  (0...days).to_a.reduce(initial_lanternfish) { process_day(_1) }
end

def build_reduced_list(lanternfish)
  lanternfish.each_with_object(9.times.map { 0 }) do |fish, reduced_list|
    reduced_list[fish] += 1
  end
end

puts File.read("./input.txt")
       .strip
       .split(",")
       .map(&:to_i)
       .then { |lanternfish| build_reduced_list(lanternfish) }
       .then { |lanternfish_reduced| process_days(lanternfish_reduced, 256) }
       .sum
