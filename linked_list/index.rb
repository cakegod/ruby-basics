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
    iterate { |node, i| return i + 1 if tail?(node) }
  end

  def tail
    iterate { |node| return node if tail?(node) }
  end

  def at(index)
    iterate do |node, i|
      return node if at_correct_index?(index, i)
    end
  end

  def pop
    iterate { |node| return node.next_node = nil if node.next_node.next_node.nil? }
  end

  def find(value)
    iterate { |node| return node if node.value == value }
  end

  def contains?(value)
    !find(value).nil?
  end

  def to_s
    iterate.map { |node| "(#{node.value}) ->" }.push('nil').join(' ')
  end

  def insert_at(value, index)
    new_node = Node.new(value:)
    iterate do |node, i|
      if at_correct_index?(index, i)
        new_node.next_node = node.next_node
        node.next_node = new_node
        return
      end
    end
    raise "Invalid index: #{index} does not exist"
  end

  def iterate
    return enum_for(:iterate) unless block_given?

    node = head
    index = 0
    while node
      yield(node, index)
      index += 1
      node = node.next_node
    end
  end

  private

  def tail?(node)
    node.next_node.nil?
  end

  def at_correct_index?(first_index, second_index)
    first_index == second_index
  end
end

LinkedList.new.tap do |linked_list|
  linked_list.append(12)
  linked_list.append(22)
  linked_list.append(32)
  linked_list.append(4)
  linked_list.append(50)
  linked_list.pop
  linked_list.insert_at(99, 5)
  p linked_list.to_s
end
