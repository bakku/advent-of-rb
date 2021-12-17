# frozen_string_literal: true

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
    queue = []

    results = @adjacencies.keys.reduce({}) do |dijkstra_results, vertex|
      queue.push(vertex)
      dijkstra_results.merge({ vertex => DijkstraResult.new(Float::INFINITY, nil) })
    end

    results.tap do |r|
      r["0_0"].dist = 0

      until queue.empty?
        next_vertex = queue.min_by { |q| r[q].dist }
        queue.reject! { |q| q == next_vertex }

        p next_vertex
        p queue.size

        @adjacencies[next_vertex].each do |edge|
          next unless queue.include?(edge.vertex)

          dist = r[next_vertex].dist + edge.dist

          if dist < r[edge.vertex].dist
            r[edge.vertex] = DijkstraResult.new(dist, next_vertex)
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

grid = File.readlines("./input.txt", chomp: true)
         .map { _1.chars }

dijkstra_results = Graph.new(grid).dijkstra
puts "Resulting distance: #{dijkstra_results["99_99"].dist}"
