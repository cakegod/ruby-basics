# frozen_string_literal: true

# Handles linked list node
class Node
  attr_accessor :value, :next_node

  def initialize(**args)
    @value = args[:value] || nil
    @next_node = args[:next_node] || nil
  end
end

# Handles linked list
class LinkedList
  attr_accessor :head

  def initialize(**args)
    @head = args[:head] || nil
  end

  def append(value)
    head.nil? ? self.head = Node.new(value:) : tail.next_node = Node.new(value:)
  end

  def prepend(value)
    self.head = Node.new(value:, next_node: head)
  end

  def size
    return 0 if head.nil?

    node = head
    count = 1
    until node.next_node.nil?
      node = node.next_node
      count += 1
    end
    count
  end

  def tail
    node = head
    node = node.next_node until node.next_node.nil?
    node
  end

  def at(index)
    return head if index.zero?

    node = head
    count = 0
    until count == index
      node = node.next_node
      count += 1
    end
    node
  end

  def pop
    at(size - 2).next_node = nil
  end

  def find(value)
    node = head
    until node.next_node.nil?
      node = node.next_node
      return node if node.value == value
    end
  end

  def contains?(value)
    !find(value).nil?
  end

  def to_s
    node = head
    string = []
    until node.nil?
      string << "(#{node.value}) ->"
      node = node.next_node
    end
    string << 'nil'
    string.join(' ')
  end
end

p(LinkedList.new.tap do |linked_list|
  linked_list.append(12)
  linked_list.append(22)
  linked_list.append(32)
  linked_list.append(4)
  linked_list.append(50)
  p linked_list.tail
end)
