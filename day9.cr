def step(head, tails, direction)
  previous = head = {head[0] + direction[0], head[1] + direction[1]}
  tails = tails.map! do |tail|
    previous = if (previous[0] - tail[0]).abs > 1 || (previous[1] - tail[1]).abs > 1
                 {tail[0] + (previous[0] <=> tail[0]), tail[1] + (previous[1] <=> tail[1])}
               else
                 tail
               end
  end
  {head, tails}
end

def solve(input, tail_size)
  head = {0, 0}
  tails = [{0, 0}] * tail_size
  dirs = {"D" => {-1, 0}, "U" => {1, 0}, "L" => {0, -1}, "R" => {0, 1}}

  tail_positions = Set(Tuple(Int32, Int32)).new
  input.each do |dir, step|
    step.times do
      head, tails = step(head, tails, dirs[dir])
      tail_positions << tails.last
    end
  end
  tail_positions.size
end

input = File.read_lines("input.day9").map(&.split).map { |row| {row.first, row.last.to_i} }

puts "part1: %s" % solve(input, 1)
puts "part1: %s" % solve(input, 9)
