require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(0)
    @length = 0
  end

  # O(1)
  def [](index)
    if @length == 0
      raise "index out of bounds"
    end
  end

  # O(1)
  def []=(index, val)
    @store[index] = val
  end

  # O(1)
  def pop
    res = @store[-1]
    @store = @store[0...-1]
    @length -= 1
    res
  end

  # O(1) ammortized
  def push(val)
    @store[self.length] = val
    @length += 1
    @store
  end

  # O(1)
  def shift
  end

  # O(1) ammortized
  def unshift(val)
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
  end
end
