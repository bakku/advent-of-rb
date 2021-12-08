# frozen_string_literal: true

depths = File.readlines("./input.txt", chomp: true).map(&:to_i)

windows = (0..(depths.size-3)).to_a.map { |i| depths[i..(i+2)].sum }

puts windows.select
  .with_index { |n, i| !i.zero? && n > windows[i-1] }
  .count
