# Implement a queue with #enqueue and #dequeue, as well as a #max API,
# a method which returns the maximum element still in the queue. This
# is trivial to do by spending O(n) time upon dequeuing.
# Can you do it in O(1) amortized? Maybe use an auxiliary storage structure?

# Use your RingBuffer to achieve optimal shifts! Write any additional
# methods you need.

require_relative 'ring_buffer'

class QueueWithMax
  attr_accessor :store, :max_queue

  def initialize
    @store = RingBuffer.new
    @max_queue = []
  end

  def enqueue(val)
    @store.push(val)
    if @length == 0 || @max_queue.length == 0
      @max_queue.push(val)
    elsif @max_queue[@max_queue.length - 1] > val
      @max_queue.push(val)
    else
      if @max_queue[0] < val
        @max_queue = [val]
      end
      @max_queue.length do | i |
        if @max_queue[@max_queue.length - 1] < val
          @max_queue.pop
          @max_queue.push(val)
          break
        end
      end
    end
  end

  def dequeue
    res = @store.shift
    @max_queue.shift if @max_queue[0] == res
    res
  end

  def max
    @max_queue[0]
  end

  def length
    @store.length
  end

end
