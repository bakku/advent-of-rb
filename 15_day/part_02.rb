# frozen_string_literal: true

require 'set'

Edge = Struct.new(:dist, :vertex)
DijkstraResult = Struct.new(:dist, :prev)

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def neighbours(max_x, max_y)
    possible_neighbours = [
      Point.new(x - 1, y), Point.new(x, y - 1),
      Point.new(x + 1, y), Point.new(x, y + 1)
    ]

    possible_neighbours.select do |neighbour|
      neighbour.x >= 0 && neighbour.x <= max_x &&
        neighbour.y >= 0 && neighbour.y <= max_y
    end
  end

  def to_s
    "#{x}_#{y}"
  end
end

class Graph
  def initialize(grid)
    @adjacencies = parse_grid(grid)
  end

  def dijkstra
    possible_elements = Set.new

    results = @adjacencies.keys.each_with_object({}) do |vertex, dijkstra_results|
      dijkstra_results[vertex] = {
        result: DijkstraResult.new(Float::INFINITY, nil),
        finished: false
      }
    end

    results.tap do |r|
      counter = 0
      r["0_0"][:result].dist = 0

      possible_elements.add("0_0")

      until possible_elements.empty?
        counter += 1
        next_vertex = possible_elements.min_by { |q| r[q][:result].dist }

        r[next_vertex][:finished] = true
        possible_elements.delete(next_vertex)

        @adjacencies[next_vertex].each do |edge|
          next if r[edge.vertex][:finished]

          dist = r[next_vertex][:result].dist + edge.dist

          possible_elements.add(edge.vertex)

          if dist < r[edge.vertex][:result].dist
            r[edge.vertex][:result] = DijkstraResult.new(dist, next_vertex)
          end
        end
      end
    end
  end

  private

  def parse_grid(grid)
    max_x = grid.first.size - 1
    max_y = grid.size - 1

    points = (0..max_y).flat_map do |y|
      (0..max_x).map do |x|
        Point.new(x, y)
      end
    end

    points.reduce({}) do |adjacencies, point|
      adjacencies.tap do |adj|
        adj[point.to_s] = []

        point.neighbours(max_x, max_y).each do |n|
          adj[point.to_s] << Edge.new(grid[n.y][n.x].to_i, n.to_s)
        end
      end
    end
  end
end

def expand_grid(grid)
  new_grid = grid.cycle.take(grid.size * 5).map do |row|
    row.cycle.take(row.size * 5)
  end

  new_grid.map.with_index do |row,y|
    row.map.with_index do |cell,x|
      new_val = (cell.to_i + (x / grid.first.size.to_f).to_i + (y / grid.size.to_f).to_i)

      if new_val >= 10
        ((new_val % 10) + 1).to_s
      else
        new_val.to_s
      end
    end
  end
end

grid = File.readlines("./input.txt", chomp: true)
         .map { _1.chars }

expanded_grid = expand_grid(grid)

dijkstra_results = Graph.new(expanded_grid).dijkstra
puts "Resulting distance: #{dijkstra_results["499_499"][:result].dist}"
