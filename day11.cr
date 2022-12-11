record(Monkey, items : Array(Int64), operation : Tuple(String, Int32?), test : Int32, t : Int32, f : Int32) do
  def inspect_item(level)
    other = operation[1] || level
    operation[0] == "+" ? level + other : level * other
  end

  def target(level)
    level.remainder(test) == 0 ? t : f
  end
end

def read(input)
  input.each_slice(7).map do |lines|
    items = lines[1].split(/\D+/, remove_empty: true).map &.to_i64
    op = lines[2].sub(/  Operation: new = /, "").split
    operation = {op[1], op[2][0] == 'o' ? nil : op[2].to_i}
    test = lines[3][-2..].strip.to_i
    t = lines[4][-1].to_i
    f = lines[5][-1].to_i
    Monkey.new(items, operation, test, t, f)
  end
end

def round(monkeys, counts, multiple)
  monkeys.each_with_index do |m, m_i|
    counts[m_i] += m.items.size
    m.items.each do |item|
      item = yield m.inspect_item(item), multiple
      monkeys[m.target(item)].items << item
    end
    m.items.clear
  end
end

def monkey_business(times, input)
  monkeys = read(input).to_a
  counts = Array(Int64).new(monkeys.size) { 0i64 }
  multiple = monkeys.map(&.test).product

  times.times { round(monkeys, counts, multiple) { |v, l| yield v, l } }
  counts.sort.last(2).product
end

input = File.read_lines("input.day11")

puts "part1: %s" % monkey_business(20, input) { |v, _| v // 3 }
puts "part2: %s" % monkey_business(10000, input) { |v, multiple| v.remainder(multiple) }
