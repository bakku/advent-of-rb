# frozen_string_literal: true

class OutputDecoder
  def initialize(line)
    @line = line
    @undecoded_numbers = line.gsub(" | ", " ").split.map { |num| num.chars.sort.join }.uniq
    @number_translation = (0..9).to_a.map { nil }
  end

  def decode
    decode_numbers

    @line.split(" | ")
      .last
      .split
      .map { |num| @number_translation.find_index { |nt| nt.sort == num.chars.sort }.to_s }
      .join
      .to_i
  end

  private

  def decode_numbers
    decode_one
    decode_four
    decode_seven
    decode_eight
    decode_three
    decode_nine
    decode_five
    decode_six
    decode_zero
    decode_two
  end

  def decode_one
    @number_translation[1] = @undecoded_numbers.find { _1.size == 2 }.chars
    @undecoded_numbers.reject! { _1 == @number_translation[1].join }
  end

  def decode_four
    @number_translation[4] = @undecoded_numbers.find { _1.size == 4 }.chars
    @undecoded_numbers.reject! { _1 == @number_translation[4].join }
  end

  def decode_seven
    @number_translation[7] = @undecoded_numbers.find { _1.size == 3 }.chars
    @undecoded_numbers.reject! { _1 == @number_translation[7].join }
  end

  def decode_eight
    @number_translation[8] = @undecoded_numbers.find { _1.size == 7 }.chars
    @undecoded_numbers.reject! { _1 == @number_translation[8].join }
  end

  def decode_three
    @number_translation[3] = @undecoded_numbers.find do |num|
      num.size == 5 && (num.chars - @number_translation[7]).size == 2
    end.chars
    @undecoded_numbers.reject! { _1 == @number_translation[3].join }
  end

  def decode_nine
    @number_translation[9] = @undecoded_numbers.find do |num|
      num.size == 6 && @number_translation[3].all? { |c| num.chars.include?(c) } &&
        (num.chars - @number_translation[3]).size == 1
    end.chars
    @undecoded_numbers.reject! { _1 == @number_translation[9].join }
  end

  def decode_five
    @number_translation[5] = @undecoded_numbers.find do |num|
      num.size == 5 && num.chars.all? { |c| @number_translation[9].include?(c) } &&
        (@number_translation[9] - num.chars).size == 1
    end.chars
    @undecoded_numbers.reject! { _1 == @number_translation[5].join }
  end

  def decode_six
    @number_translation[6] = @undecoded_numbers.find do |num|
      num.size == 6 && @number_translation[5].all? { |c| num.chars.include?(c) } &&
        (num.chars - @number_translation[5]).size == 1
    end.chars
    @undecoded_numbers.reject! { _1 == @number_translation[6].join }
  end

  def decode_zero
    @number_translation[0] = @undecoded_numbers.find { _1.size == 6 }.chars
    @undecoded_numbers.reject! { _1 == @number_translation[0].join }
  end

  def decode_two
    @number_translation[2] = @undecoded_numbers.first.chars
    @undecoded_numbers.reject! { _1 == @number_translation[2].join }
  end
end

puts File.readlines("./input.txt", chomp: true)
       .map { OutputDecoder.new(_1).decode }
       .sum
