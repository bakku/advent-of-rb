# frozen_string_literal: true

class GameBoard
  def initialize(board, random_nums)
    @board                    = initialize_board(board)
    @random_nums              = random_nums
    @initial_random_num_count = random_nums.size
  end

  def play
    next_number = nil

    while !game_over? && !@random_nums.empty?
      next_number = @random_nums.shift
      mark_number(next_number)
    end

    {
      board: @board, winning_board: game_over?,
      rounds: @initial_random_num_count - @random_nums.size,
      score: calc_score(next_number)
    }
  end

  private

  def initialize_board(board)
    board.map do |row|
      row.map do |num|
        { marked: false, number: num }
      end
    end
  end

  def mark_number(num)
    @board = @board.map do |row|
      row.map do |cell|
        cell.tap do |c|
          c[:marked] = c[:marked] || num == c[:number]
        end
      end
    end
  end

  def game_over?
    (0...(row(0).size)).any? { |row_idx| row(row_idx).all? { |num| num[:marked] } } ||
      (0...(column(0).size)).any? { |col_idx| column(col_idx).all? { |num| num[:marked] } }
  end

  def calc_score(last_choice)
    return nil unless game_over?

    unmarked_sum = @board.flatten
      .reject { |n| n[:marked] }
      .map { |n| n[:number] }
      .sum

    unmarked_sum * last_choice
  end

  def row(idx)
    @board[idx]
  end

  def column(idx)
    @board.map { _1[idx] }
  end
end

bingo_input = File.readlines("./input.txt", chomp: true)

random_choices = bingo_input[0].split(",").map(&:to_i)

puts bingo_input[2..].reject { |line| line.size.zero? }
  .each_slice(5)
  .to_a
  .map { |slice| slice.map { |row| row.split.map(&:to_i) } }
  .map { |board| GameBoard.new(board, random_choices.dup).play }
  .select { |game_result| game_result[:winning_board] }
  .min_by { |game_result| game_result[:rounds] }[:score]
