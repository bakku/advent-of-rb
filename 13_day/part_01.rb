# frozen_string_literal: true

class Grid
  def initialize(dots)
    @dots = dots
    @grid = build_grid(dots)
  end

  def fold(instruction)
    coord, value = instruction.gsub("fold along ", "").split("=")

    if coord == "x"
      Grid.new(fold_left(value.to_i))
    else
      Grid.new(fold_up(value.to_i))
    end
  end

  def size
    @dots.size
  end

  def to_s
    @grid.map do |row|
      row.map do |cell|
        if cell.nil?
          "."
        else
          "#"
        end
      end.join
    end.join("\n")
  end

  private

  def fold_left(offset)
    @dots.map do |dot|
      next dot if dot.x < offset

      difference = dot.x - offset
      Point.new(dot.x - (difference * 2), dot.y)
    end.uniq
  end

  def fold_up(offset)
    @dots.map do |dot|
      next dot if dot.y < offset

      difference = dot.y - offset
      Point.new(dot.x, dot.y - (difference * 2))
    end.uniq
  end

  def build_grid(dots)
    max_x = dots.map(&:x).max
    max_y = dots.map(&:y).max

    initial_grid = Array.new(max_y + 1) { Array.new(max_x + 1) }

    dots.reduce(initial_grid) do |grid, dot|
      grid.tap do |g|
        g[dot.y][dot.x] = "#"
      end
    end
  end
end

def parse_dots(dots)
  dots.split("\n")
    .map { Point.new(_1.split(",").first.to_i, _1.split(",").last.to_i) }
end

Point = Struct.new(:x, :y)

dots, folding = File.read("./input.txt", chomp: true)
                  .split("\n\n")
                  .then { [parse_dots(_1.first), _1.last.split("\n")] }

puts Grid.new(dots).fold(folding.first).size
