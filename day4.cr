input = File.read_lines("input.day4").map &.split(/[,-]/).map(&.to_i)

puts "part1: %s" % input.count { |(f1, f2, s1, s2)| (f1 <= s1 <= s2 <= f2) || (s1 <= f1 <= f2 <= s2) }
puts "part2: %s" % input.count { |(f1, f2, s1, s2)| (f1 <= s1 <= f2) || (s1 <= f1 <= s2) }
