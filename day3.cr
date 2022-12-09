def common_priority(*chars)
  chars.reduce { |acc, el| acc & el }.sum do |char|
    char.in?('a'..'z') ? char - 'a' + 1 : char - 'A' + 27
  end
end

input = File.read_lines("input.day3").map(&.chars)

compartments = input.map { |chars|
  {chars[0..(chars.size//2 - 1)], chars[(chars.size//2)..]}
}.sum { |(x, y)| common_priority(x, y) }

puts "part1: %s" % compartments

badges = input.each_slice(3).sum { |(x, y, z)| common_priority(x, y, z) }
puts "part2: %s" % badges
