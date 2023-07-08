# frozen_string_literal: true

NUMBER_OF_COLUMNS = 7
NUMBER_OF_ROWS = 6

# Handles columns of the gameboard
class Column
  attr_reader :rows

  VERTICAL_WIN_COMBINATIONS = (0...NUMBER_OF_ROWS).each_cons(4).to_a

  def initialize(rows: Array.new(NUMBER_OF_ROWS, ''))
    @rows = rows
  end

  def place_marker(marker)
    raise 'column is full' if last_empty_position.nil?

    rows[last_empty_position] = marker
  end

  def check_vertical(marker)
    VERTICAL_WIN_COMBINATIONS.find { |combination| combination.all? { |index| rows[index] == marker } }
  end

  private

  def last_empty_position
    rows.index('')
  end
end

# Handles the gameboard
class GameBoard
  attr_reader :board

  def initialize(board: Array.new(NUMBER_OF_COLUMNS) { Column.new })
    @board = board
    @last = nil
  end

  def place_marker(column, marker)
    unless column.between?(0, NUMBER_OF_COLUMNS)
      raise ArgumentError, "invalid column (given #{column} , expected value between (0 and 6))"
    end

    board[column].place_marker(marker)
  end

  def check_win(_marker)
    [[0, 0], [1, 0], [2, 0], [3, 0]]
  end

  private

  attr_writer :board
  attr_accessor :last
end
