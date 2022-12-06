def find_start(input, count)
  count + input.each_cons(count, reuse: true).index!(&.uniq.size.==(count))
end

input = File.read("input.day6").chars

puts "part1: %s" % find_start(input, 4)
puts "part2: %s" % find_start(input, 14)
