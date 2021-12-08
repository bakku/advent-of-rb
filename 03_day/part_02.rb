# frozen_string_literal: true

def calc_bit_occurrence(bit_nums, pos)
  bit_nums.each_with_object([0, 0]) do |num, counts|
    counts.tap do |c|
      c[num.chars[pos].to_i] += 1
    end
  end
end

def most_common_bit(bit_nums, pos)
  counts = calc_bit_occurrence(bit_nums, pos)

  return 1 if counts.max == counts.min

  counts.index(counts.max)
end

def least_common_bit(bit_nums, pos)
  counts = calc_bit_occurrence(bit_nums, pos)

  return 0 if counts.max == counts.min

  counts.index(counts.min)
end

def calc_rating(bit_numbers, pos, &block)
  return bit_numbers.first.to_i(2) if bit_numbers.size == 1

  mcb = block.call(bit_numbers, pos)

  next_bit_numbers = bit_numbers.select { |bn| bn.chars[pos].to_i == mcb }

  calc_rating(next_bit_numbers, pos + 1, &block)
end

def oxygen_rating(bit_numbers, pos) = calc_rating(bit_numbers, pos, &method(:most_common_bit))

def co2_rating(bit_numbers, pos) = calc_rating(bit_numbers, pos, &method(:least_common_bit))

bit_numbers = File.readlines("./input.txt", chomp: true)

puts oxygen_rating(bit_numbers, 0) * co2_rating(bit_numbers, 0)
