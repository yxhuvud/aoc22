require "bit_array"

record(Pos, x : Int32, y : Int32) do
  def +(other)
    Pos.new(x + other.x, y + other.y)
  end
end

def parse(lines)
  map = Array(Pos).new

  lines.each &.each_cons(2) do |(p1, p2)|
    if p1.x - p2.x != 0
      p1.x.to(p2.x).each do |x|
        map << Pos.new(x, p1.y)
      end
    else
      p1.y.to(p2.y).each do |y|
        map << Pos.new(p1.x, y)
      end
    end
  end
  ymax = map.max_of &.y
  map2 = Array(BitArray).new(2*ymax + 4) { BitArray.new(ymax + 2) }
  offset = ymax + 1 - 500
  map.each { |p| map2[p.x + offset][p.y] = true }
  map2
end

def drip(map, floor, current = nil)
  ymax = floor ? map[0].size : map[0].size - 1
  current ||= Pos.new(ymax, 0)

  return floor if current.y == ymax
  return true if map[current.x][current.y]

  stable =
    drip(map, floor, current + Pos.new(0, 1)) &&
      drip(map, floor, current + Pos.new(-1, 1)) &&
      drip(map, floor, current + Pos.new(1, 1))

  map[current.x][current.y] = true if stable
  return stable
end

input = File.read_lines("input.day14")
lines = input.map(&.split(/ -> /).map(&.split(',').map { |v| v.to_i }).map { |vs| Pos.new(vs[0], vs[1]) })

map = parse(lines)
map_count = map.sum &.count(true)

drip(map, false)
puts "part1: %s" % (map.sum &.count(true) - map_count)

drip(map, true)
puts "part2: %s" % (map.sum &.count(true) - map_count)
