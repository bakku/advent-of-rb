# frozen_string_literal: true

def evaluate_command(command, positions)
  instruction, x = command.split(" ")

  case instruction
  when "forward"
    positions.tap { |p| p[:h] = p[:h] + x.to_i }
  when "down"
    positions.tap { |p| p[:d] = p[:d] + x.to_i }
  when "up"
    positions.tap { |p| p[:d] = p[:d] - x.to_i }
  end
end

commands = File.readlines("./input.txt", chomp: true)

puts commands.each_with_object({ h: 0, d: 0 }, &method(:evaluate_command))
       .then { |positions| positions[:d] * positions[:h] }
