# frozen_string_literal: true

def should_swap?(array, first, second)
  array[first] > array[second]
end

def swap_values(array, first, second)
  array[first], array[second] = array[second], array[first]
end

def bubble_sort(array)
  skipped = 0
  until skipped.eql?(array.length)
    (array.length - 1 - skipped).times do |index|
      swap_values(array, index, index + 1) if should_swap?(array, index, index + 1)
    end
    skipped += 1
  end
  array
end