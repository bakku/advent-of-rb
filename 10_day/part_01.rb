# frozen_string_literal: true

CHAR_SCORE_MAPPING = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

CHAR_START_END_MAPPING = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

class Stack
  def initialize
    @stack = []
  end

  def pop = @stack.shift

  def push(x) = @stack.prepend(x)
end

def check_line(line)
  stack = Stack.new
  chars = line.chars

  until chars.empty?
    c = chars.shift

    case c
    when "(", "{", "[", "<"
      stack.push(c)
    when ")", "}", "]", ">"
      return c if CHAR_START_END_MAPPING.key(c) != stack.pop
    end
  end

  nil
end

p File.readlines("./input.txt", chomp: true)
  .map(&method(:check_line))
  .compact
  .map { |err| CHAR_SCORE_MAPPING.fetch(err) }
  .sum
