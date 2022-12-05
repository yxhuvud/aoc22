input = File.read_lines("input.day5")

input_stacks = input.shift(9).map(&.chars).transpose
stacks = Array(Array(Char)).new
input_stacks.each do |row|
  next unless row.last.in?('1'..'9')

  while row.first == ' '
    row.shift
  end
  row.pop
  stacks << row.reverse
end

input.shift

def compute(input, stacks)
  stacks = stacks.map &.dup
  input.each do |line|
    nums = line.split(/\D+/, remove_empty: true).map &.to_i

    from_stack = stacks[nums[1] - 1]
    to_stack = stacks[nums[2] - 1]
    count = nums[0]

    yield from_stack, to_stack, count
  end
  stacks.map(&.last).join
end

puts "part1: %s" % compute(input, stacks) { |from, to, count| count.times { to.push from.pop } }
puts "part2: %s" % compute(input, stacks) { |from, to, count| to.concat from.pop(count) }
