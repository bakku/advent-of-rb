# frozen_string_literal: true

CHAR_SCORE_MAPPING = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

CHAR_START_END_MAPPING = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

class Array
  def median
    sorted = self.sort
    size = sorted.size
    center = size / 2
    sorted[center]
  end
end

class Stack
  def initialize
    @stack = []
  end

  def pop = @stack.shift

  def push(x) = @stack.prepend(x)

  def to_a = @stack
end

def completion_string(line)
  stack = Stack.new
  chars = line.chars

  until chars.empty?
    c = chars.shift

    case c
    when "(", "{", "[", "<"
      stack.push(c)
    when ")", "}", "]", ">"
      return nil if CHAR_START_END_MAPPING.key(c) != stack.pop
    end
  end

  stack.to_a.map { CHAR_START_END_MAPPING.fetch(_1) }
end

def calc_completion_score(completion_string)
  completion_string.reduce(0) do |score, n|
    new_score = score * 5
    new_score + CHAR_SCORE_MAPPING[n]
  end
end

p File.readlines("./input.txt", chomp: true)
  .map(&method(:completion_string))
  .compact
  .map(&method(:calc_completion_score))
  .sort
  .median
