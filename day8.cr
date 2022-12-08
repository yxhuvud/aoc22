input = File.read("input.day8").lines.map &.chars.map(&.to_i)
xmax = input.size - 1
ymax = input[0].size - 1

def mark_visible(input, iter, visible)
  best_so_far = -1
  iter.each do |coord|
    loc = yield(coord)
    value = input.dig(*loc)
    if value > best_so_far
      best_so_far = value
      visible << loc
    end

    return if value == 9
  end
end

visible = Set(Tuple(Int32, Int32)).new
0.to(xmax).each do |x|
  mark_visible(input, 0.to(ymax), visible) { |y| {x, y} }
  mark_visible(input, ymax.to(0), visible) { |y| {x, y} }
end
0.to(ymax) do |y|
  mark_visible(input, 0.to(xmax), visible) { |x| {x, y} }
  mark_visible(input, xmax.to(0), visible) { |x| {x, y} }
end

puts "part1: %s" % visible.size

def count_trees(input, iter, height)
  count = 0
  iter.each do |coord|
    count += 1
    break if input.dig(*yield(coord)) >= height
  end
  count
end

scenic_score = 1.to(xmax - 1).max_of do |xpos|
  1.to((ymax - 1)).max_of do |ypos|
    current = input.dig(xpos, ypos)
    count_trees(input, (xpos + 1).to(xmax), current) { |x| {x, ypos} } *
      count_trees(input, (xpos - 1).to(0), current) { |x| {x, ypos} } *
      count_trees(input, (ypos + 1).to(ymax), current) { |y| {xpos, y} } *
      count_trees(input, (ypos - 1).to(0), current) { |y| {xpos, y} }
  end
end

puts "part2: %s" % scenic_score
