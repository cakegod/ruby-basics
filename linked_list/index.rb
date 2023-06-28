# frozen_string_literal: true

# Handles linked list node
class Node
  attr_reader :value, :next_node

  def initialize(**args)
    @value = args[:value] || nil
    @next_node = args[:next_node] || nil
  end

  def swap_next_node(node)
    self.next_node = node
  end

  def swap(node)
    self.next_node = node.next_node
    node.next_node = self
  end

  def pop
    self.next_node = nil if penultimate?
  end

  def tail?
    next_node.nil?
  end

  protected

  def penultimate?
    next_node.next_node.nil?
  end

  attr_writer :value, :next_node
end

# Handles linked list
class LinkedList
  attr_reader :head

  def initialize(**args)
    @head = args[:head] || nil
  end

  def append(value)
    new_node = LinkedList.create_node(value)

    if head.nil?
      self.head = new_node
    else
      tail&.swap_next_node(new_node)
    end
  end

  def prepend(value)
    self.head = Node.new(value:, next_node: head)
  end

  def size
    iterate.each_with_index { |node, index| return index + 1 if node.tail? }
  end

  def tail
    iterate.find(&:tail?)
  end

  def at(index_arg)
    iterate.find.each_with_index { |_, index| index_arg == index }
  end

  def pop
    iterate(&:pop)
  end

  def find(value)
    iterate.find { |node| node.value == value }
  end

  def contains?(value)
    !!find(value)
  end

  def to_s
    iterate.map { |node| "(#{node.value}) ->" }.push('nil').join(' ')
  end

  def insert_at(value, index)
    at(index).then { |node| LinkedList.create_node(value).swap(node) }
  end

  def iterate
    return enum_for(:iterate) unless block_given?

    node = head
    while node
      yield(node)
      node = node.next_node
    end
  end

  def self.create_node(value)
    Node.new(value:)
  end

  private

  attr_writer :head
end

p(LinkedList.new.tap do |linked_list|
  linked_list.append(12)
  linked_list.append(22)
  linked_list.append(32)
  linked_list.append(4)
  linked_list.append(50)
  linked_list.insert_at(241, 2)
  p "At: #{linked_list.at(2).value}"
  p linked_list.to_s
end)
