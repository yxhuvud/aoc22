input =
  File.read("input.day1")
    .split(/\n\n/)
    .map(&.split.map &.to_i)

calories = input.map(&.sum).sort
puts "part1: %s" % calories.last
puts "part2: %s" % calories.last(3).sum
