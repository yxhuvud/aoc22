require "string_scanner"

struct Packet
  property :entries
  include Comparable(Packet)

  def initialize(i = nil)
    @entries = Array(Packet | Int32).new
    @entries << i if i
  end

  def <<(value)
    @entries << value
  end

  def <=>(other)
    entries.each_with_index do |e, i|
      o = other.is_a?(Packet) ? other.entries[i]? : other
      return 1 if o.nil?

      v = if e.is_a?(Int32) && o.is_a?(Int32)
            e <=> o
          elsif e.is_a?(Packet) && o.is_a?(Packet)
            e <=> o
          elsif e.is_a?(Packet)
            e <=> Packet.new(o.as(Int32))
          elsif o.is_a?(Packet)
            Packet.new(e.as(Int32)) <=> o
          else
            raise "unreachable"
          end
      return v if v != 0
    end
    other.entries.size > entries.size ? -1 : 0
  end
end

def parse(line)
  s = StringScanner.new(line)
  s.offset += 1
  current = Packet.new
  stack = [] of Packet

  loop do
    case s.peek 1
    when "["
      stack << current
      current = Packet.new
      stack.last << current
      s.offset += 1
    when "]"
      s.offset += 1
      return current if s.eos?
      current = stack.pop
    when ","
      s.offset += 1
    else
      current << (s.scan /\d+/).not_nil!.to_i
    end
  end
end

input = File.read_lines("input.day13")
parsed = input.compact_map { |line| line.empty? ? nil : parse(line) }

puts "part1: %s" % parsed.each_slice(2, reuse: true).with_index.sum { |(p1, p2), index| p1 <= p2 ? index + 1 : 0 }
puts "part2: %s" % ((parsed.count(&.<(parse("[[2]]"))) + 1) * (parsed.count(&.<(parse("[[6]]"))) + 2))
