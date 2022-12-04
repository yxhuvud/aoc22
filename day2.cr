input =
  File.read("input.day2")
    .lines.map(&.split).map { |vs| {vs[0][0] - 'A', vs[1][0] - 'X'} }

def wins_over(value)
  (value + 1) % 3
end

score = input.sum do |other, us|
  us + 1 +
    if wins_over(other) == us
      6
    elsif other == us
      3
    else
      0
    end
end
puts "part1: %s" % score

score = input.sum { |other, result| 3 * result + wins_over(other + result - 2) + 1 }
puts "part2: %s" % score
