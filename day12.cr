require "bit_array"

record Pos, x : Int32, y : Int32 do
  def neighbours(map)
    {
      Pos.new(x &+ 1, y),
      Pos.new(x &- 1, y),
      Pos.new(x, y &+ 1),
      Pos.new(x, y &- 1),
    }.each { |pn| yield pn if (0 <= pn.x < map.size) && (0 <= pn.y < map[0].size) }
  end
end

def test(map, from, target, backwards = false)
  seen = Array(BitArray).new(map.size) { BitArray.new(map[0].size) }
  queue = Deque{ {from, 0} }

  while element = queue.shift?
    p, steps = element
    current = map[p.x][p.y]
    return steps if target == current

    p.neighbours(map) do |pn|
      unless seen[pn.x][pn.y] || (backwards ? current - map[pn.x][pn.y] > 1 : map[pn.x][pn.y] - current > 1)
        queue << {pn, steps &+ 1}
        seen[pn.x][pn.y] = true
      end
    end
  end
  raise "unreachable"
end

start = Pos.new(20, 0)
map = File.read_lines("input.day12").map &.chars
target = Pos.new(20, map[20].index! { |c| c == 'E' })

map[20][0] = 'a'
map[20][target.y] = 'z' + 1

puts "part1: %s" % test(map, start, 'z' + 1)
puts "part2: %s" % test(map, target, 'a', backwards: true)
