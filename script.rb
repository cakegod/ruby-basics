# frozen_string_literal: true

require 'open-uri'

# class
class Hamlet
  def initialize
    @is_hamlet_speaking = false
  end

  def toggle_hamlet_speaking
    self.is_hamlet_speaking = !is_hamlet_speaking
  end

  def process_line(line)
    toggle_hamlet_speaking if hamlet_is_speaking?(line)

    puts line if is_hamlet_speaking
  end

  def hamlet_is_speaking?(line)
    is_hamlet_speaking && line.match("Ham\.") || (line.match(/^  [A-Z]/) || line.strip.empty?)
  end

  attr_accessor :is_hamlet_speaking
end

hamlet = Hamlet.new

File.open('hamlet.txt', 'r') do |file|
  file.readlines.each do |line|
    hamlet.process_line(line)
  end
end
