require_relative "static_array"
require "byebug"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @store = StaticArray.new(0)
    @capacity = 8
  end

  # O(1)
  def [](index)
    if @length == 0 || index >= @length
      raise "index out of bounds"
    else
      @store[index]
    end
  end

  # O(1)
  def []=(index, value)
    if index >= @length
      raise "index out of bounds"
    end
    @store[index] = value
  end

  # O(1)
  def pop
    if @length <= 0
      raise "index out of bounds"
    end
    @length -= 1
    res = @store[-1]
    @store = @store[0...-1]
    res
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    @length += 1
    @store[@length - 1] = val
    if @length > 8
      self.resize!
    end
  end

  # O(n): has to shift over all the elements.
  def shift
    first = self[0]
    (1...@length).to_a.each do | i |
      self[i - 1] = self[i]
    end
    self[-1] = first
    self.pop
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if @length != 0
      self.push(self[@length - 1])
      (@length - 2).downto(0) do | i |
        self[i + 1] = self[i]
      end
      self[0] = val
    else
      self.push(val)
    end
    self
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity += 8
  end
end
