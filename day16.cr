require "bit_array"

input = File.read_lines("input.day16")
mapping = Hash(String, Int8).new
valves = input.to_h do |line|
  segs = line.split(/[ ,]/, remove_empty: true)
  {to_mapping(segs[1], mapping), {segs[4].scan(/\d+/)[0][0].to_i, segs[9..].map { |s| to_mapping(s, mapping) }}}
end

tunnel_distances = Hash(Tuple(Int8, Int8), Int8).new
valves.each do |valve, data|
  data.last.each do |tunnel|
    tunnel_distances[{tunnel, valve}] = tunnel_distances[{valve, tunnel}] = 1
  end
end
5.times do |i| # Calculate transitive distances
  valves.each do |valve, data|
    valves.each do |target, _data|
      next if tunnel_distances[{valve, target}]?
      data.last.each do |neigh|
        if tunnel_distances[{neigh, target}]?
          if tunnel_distances[{valve, target}]?
            if tunnel_distances[{neigh, target}] + 1 < tunnel_distances[{valve, target}]
              tunnel_distances[{target, valve}] = tunnel_distances[{valve, target}] = tunnel_distances[{neigh, target}] + 1
            end
          else
            tunnel_distances[{target, valve}] = tunnel_distances[{valve, target}] = tunnel_distances[{neigh, target}] + 1
          end
        end
      end
    end
  end
end

valves.reject! { |k, v| v[0] == 0 }

puts "part1: %s" % solve16(mapping, {30i8, 0i8}, tunnel_distances, valves)
puts "part2: %s" % solve16(mapping, {26i8, 26i8}, tunnel_distances, valves)

alias State = Tuple(Tuple(Int8, Int8), Int8, Int8, BitArray, Int32)

def solve16(mapping, start, tunnel_distances, valves)
  queue = LuckyFrontQueue(State).new(30, -start.sum)
  queue.insert({start, mapping["AA"], mapping["AA"], BitArray.new(mapping.size), 0}, -start.sum)
  seen = Set(Tuple(Tuple(Int8, Int8), Tuple(Int8, Int8), BitArray)).new

  while s = queue.pull
    state, done = s
    return state.last if done == 0

    each_neighbour(state, valves, tunnel_distances) do |*state2|
      f1 = state2[0][0] < state2[0][1] ? {state2[0][0], state2[0][1]} : {state2[0][1], state2[0][0]}
      f2 = state2[1] < state2[2] ? {state2[1], state2[2]} : {state2[2], state2[1]}
      fingerprint = {f1, f2, state2[3]}
      queue.insert(state2, -state2.first.sum) unless seen.includes?(fingerprint)
      seen << fingerprint
    end
  end
end

class LuckyFrontQueue(T)
  def initialize(front_width : Int32, current : Int32)
    @current = current
    @size = 0
    @front = Deque(Deque(T)).new(front_width) { Deque(T).new }
    @bucket_count = front_width
  end

  def pull : Tuple(T, Int32)?
    return nil if @size == 0

    @size -= 1
    until !@front[0].empty?
      @current += 1
      @front.rotate! 1
      @front[0].sort_by! { |el| -el.last }
      # Throw away some search space. It was unlucky.
      @front[0].pop((@front[0].size - 10).clamp(0..))
    end

    {@front[0].shift, @current}
  end

  def insert(value : T, prio : Int32)
    @size += 1
    offset = prio - @current
    @front[offset].push value
  end
end

def to_mapping(string, mapping)
  mapping[string]? ? mapping[string] : (mapping[string] = mapping.size.to_i8)
end

def each_neighbour(state, valves, tunnel_distances)
  remaining, elfp, elephantp, open_valves, pressure = state
  elf, elephant = remaining

  candidates = valves.keys.each do |valve|
    next if open_valves[valve]

    visited = open_valves.dup
    visited[valve] = true
    rate = valves[valve][0]

    if elf == elephant
      steps = tunnel_distances[{elfp, valve}] + 1
      yield({elf - steps, elephant}, valve, elephantp, visited, pressure + rate * (elf - steps))
      steps = tunnel_distances[{elephantp, valve}] + 1
      yield({elf, elephant - steps}, elfp, valve, visited, pressure + rate * (elephant - steps))
    elsif elf > elephant
      steps = tunnel_distances[{elfp, valve}] + 1
      if elf - steps < 0
        yield({0i8, elephant}, elfp, elephantp, open_valves, pressure)
      else
        yield({elf - steps, elephant}, valve, elephantp, visited, pressure + rate * (elf - steps))
      end
    else
      steps = tunnel_distances[{elephantp, valve}] + 1
      if elephant - steps < 0
        yield({elf, 0i8}, elfp, elephantp, open_valves, pressure)
      else
        yield({elf, elephant - steps}, elfp, valve, visited, pressure + rate * (elephant - steps))
      end
    end
  end
end
