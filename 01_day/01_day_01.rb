# frozen_string_literal: true

depths = File.readlines("./01_input_01.txt", chomp: true).map(&:to_i)
puts depths.select.with_index { |n, i| !i.zero? && n > depths[i-1] }.count
