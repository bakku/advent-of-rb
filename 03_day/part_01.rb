# frozen_string_literal: true

bit_numbers = File.readlines("./input.txt", chomp: true)
initial_ary = Array.new(bit_numbers.first.size).map { [0, 0] }

final_counts = bit_numbers.each_with_object(initial_ary) do |num, counts|
  counts.tap do |c|
    num.split("").each_with_index do |bit, i|
      c[i][bit.to_i] += 1
    end
  end
end

gamma = final_counts.map { |c| c.index(c.max) }
          .join("")
          .to_i(2)

epsilon = final_counts.map { |c| c.index(c.min) }
            .join("")
            .to_i(2)

puts gamma * epsilon
