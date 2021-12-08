# frozen_string_literal: true

def evaluate_command(command, positions)
  instruction, x = command.split(" ")

  case instruction
  when "forward"
    positions.tap do |p|
      p[:h] = p[:h] + x.to_i
      p[:d] = p[:d] + p[:a] * x.to_i
    end
  when "down"
    positions.tap { |p| p[:a] = p[:a] + x.to_i }
  when "up"
    positions.tap { |p| p[:a] = p[:a] - x.to_i }
  end
end

commands = File.readlines("./input.txt", chomp: true)

puts commands.each_with_object({ h: 0, d: 0, a: 0 }, &method(:evaluate_command))
       .then { |positions| positions[:d] * positions[:h] }
