input = File.read("input.day7").lines
sizes = Array(Int32).new

def traverse(input, sizes)
  size = 0
  while line = input.shift?
    parts = line.split
    case line[0]
    when '$'
      if parts[1] == "cd" && parts[2] == ".."
        sizes << size
        return size
      elsif parts[1] == "cd"
        size += traverse(input, sizes)
      end
    when 'd'
    else
      size += parts.first.to_i
    end
  end
  size
end

total_size = traverse(input, sizes)
puts "part1: %s" % sizes.select(&.<=(100000)).sum

needed = 30000000 - (70000000 - total_size)
puts "part2: %s" % sizes.select(&.>(needed)).min
