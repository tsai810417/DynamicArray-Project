require_relative "static_array"
require 'byebug'

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @length = 0
    @capacity = 8
    @start_idx = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[(index + @start_idx) % @capacity]
  end

  # O(1)
  def []=(index, val)
    @store[(index + @start_idx) % @capacity] = val
  end

  # O(1)
  def pop
    if @length <= 0
      raise "index out of bounds"
    end
    res = @store[(@start_idx + @length - 1) % @capacity]
    @length -= 1
    res
  end

  # O(1) ammortized
  def push(val)
    if @length == @capacity
      self.resize!
    end
    @store[(@start_idx + @length) % @capacity] = val
    @length += 1
  end

  # O(1)
  def shift
    if @length <= 0
      raise "index out of bounds"
    end
    res = @store[@start_idx]
    @length -= 1
    @store[@start_idx] = nil
    @start_idx = (@start_idx + 1) % @capacity
    res
  end

  # O(1) ammortized
  def unshift(val)
    if @length == @capacity
      self.resize!
    end
    if @length == 0
      @start_idx = 0
    elsif @start_idx >= 1
      @start_idx -= 1
    else
      @start_idx = @capacity - 1
    end
    @store[@start_idx] = val
    @length += 1
    @store
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    if index >= @length || @length == 0
      raise "index out of bounds"
    end
  end

  def resize!
    @capacity += 8
    new_store = StaticArray.new(@capacity)
    new_store[0...@start_idx] = @store[0...@start_idx]
    new_store[(@start_idx + 8)...@capacity] = @store[@start_idx...@length]
    @start_idx += 8
    @store = new_store
  end
end
