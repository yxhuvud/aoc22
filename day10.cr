def signal(x, c)
  c.in?(20, 60, 100, 140, 180, 220) ? x * c : 0
end

def mark(x, cycle)
  DISPLAY << (x - 1 <= cycle % 40 <= x + 1 ? '#' : '.')
end

input = File.read_lines("input.day10").map &.split
x = 1
cycle = 1
DISPLAY = Array(Char).new
strength = 0

input.each do |line|
  case line[0]
  when "noop"
    mark(x, cycle)
    strength += signal(x, cycle)
    cycle += 1
  when "addx"
    strength += signal(x, cycle)
    strength += signal(x, cycle + 1)
    mark(x, cycle)
    x += line[1].to_i
    mark(x, cycle + 1)
    cycle += 2
  end
end

puts "part1: %s" % strength
puts "part2:"
DISPLAY.each_slice(40).each { |pxs| puts pxs.join }
