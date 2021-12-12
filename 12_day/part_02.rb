# frozen_string_literal: true

class Graph
  def initialize(edges)
    @vertices    = edges.flatten.uniq
    @edges       = edges
    @adjacencies = build_adjacency_hash
  end

  def find_paths
    [].tap do |paths|
      dfs("start", ["start"], paths)
    end
  end

  def to_s
    @adjacencies.to_s
  end

  private

  def build_adjacency_hash
    @vertices.map do |v|
      adjacencies = @edges.select { |e| e.first == v || e.last == v }
                      .map { (_1 - [v]).first }

      [v, adjacencies]
    end.to_h
  end

  def dfs(node, current_path, found_paths)
    if node == "end"
      found_paths << current_path
      return
    end

    @adjacencies[node].each do |adjacency|
      next if ["start", "end"].include?(adjacency) && current_path.include?(adjacency)
      next if small_cave?(adjacency) && small_cave_forbidden?(current_path, adjacency)

      dfs(adjacency, current_path + [adjacency], found_paths)
    end
  end

  def small_cave_forbidden?(current_path, cave)
    current_path.include?(cave) &&
      current_path.tally.find { |k,v| small_cave?(k) && v > 1 }
  end

  def small_cave?(c) = c.downcase == c
end

edges = File.readlines("./input.txt", chomp: true)
  .map { _1.split("-") }

p Graph.new(edges)
    .find_paths
    .count
