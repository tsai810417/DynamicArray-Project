require_relative "static_array"
require 'byebug'

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, val)
    @store[index] = val
  end

  # O(1)
  def pop
    if @length <= 0
      raise "index out of bounds"
    end
    res = @store[@length - 1]
    @store = @store[0...-1]
    @length -= 1
    res
  end

  # O(1) ammortized
  def push(val)
    if @length == @capacity
      self.resize!
    end
    @store[self.length] = val
    @length += 1
    @store[0..@length - 1]
  end

  # O(1)
  def shift
    if @length <= 0
      raise "index out of bounds"
    end
    res = @store[0]
    @length -= 1
    @store = @store[1..@length]
    res
  end

  # O(1) ammortized
  def unshift(val)
    new_arr = StaticArray.new(8)
    new_arr[0] = val
    new_arr[1..@length] = @store[0..@length - 1]
    @length += 1
    @store = new_arr
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
    new_store = StaticArray.new(16)
    @capacity = 16
    new_store[0..7] = @store[0..7]
    @store = new_store
  end
end
