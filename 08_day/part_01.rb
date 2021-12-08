# frozen_string_literal: true

p File.readlines("./input.txt", chomp: true)
  .map { _1.split(" | ").last }
  .flat_map { _1.split }
  .count { [2, 4, 3, 7].include?(_1.size) }
