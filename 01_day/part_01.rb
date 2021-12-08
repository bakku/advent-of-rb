# frozen_string_literal: true

depths = File.readlines("./input.txt", chomp: true).map(&:to_i)
puts depths.select.with_index { |n, i| !i.zero? && n > depths[i-1] }.count
