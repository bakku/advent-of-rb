# frozen_string_literal: true

Rule = Struct.new(:template, :insertion)

class String
  def indices(pattern)
    [].tap do |ary|
      last_index = self.index(pattern)

      until last_index.nil?
        ary << last_index

        last_index = self.index(pattern, last_index + 1)
      end
    end
  end

  def insert_at(idx, str)
    self[0...idx] + str + self[idx..]
  end
end

def step(template, rules)
  index_mapping = (0...template.size).to_a

  insertions = rules.flat_map do |rule|
    template.indices(rule.template).map { |idx| [idx + 1, rule.insertion] }
  end

  insertions.reduce(template) do |t, (idx, insertion)|
    t.insert_at(index_mapping[idx], insertion).tap do
      index_mapping.map!.with_index do |mapping, i|
        if i < idx
          mapping
        else
          mapping + 1
        end
      end
    end
  end
end

template, rules = File.read("./input.txt", chomp: true)
  .split("\n\n")
  .then { [_1.first, _1.last.split("\n").map { |r| Rule.new(r.split(" -> ").first, r.split(" -> ").last) }] }

occurrences = (1..10).reduce(template) { |t,_| step(t, rules) }
                .chars
                .tally
                .sort_by { |_, v| v }

p occurrences.last.last - occurrences.first.last
