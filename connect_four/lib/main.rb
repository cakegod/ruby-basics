# frozen_string_literal: true

NUMBER_OF_COLUMNS = 7

# Handles columns of the gameboard
class Column

  NUMBER_OF_ROWS = 6
  NUMBER_OF_ROWS = 6
  VERTICAL_WIN_COMBINATIONS = (0...NUMBER_OF_ROWS).each_cons(4).to_a.freeze
  HORIZONTAL_WIN_COMBINATIONS = (0...NUMBER_OF_COLUMNS).each_cons(4).to_a.freeze

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
    rows.rindex('')
  end

  attr_reader :rows

end

# Handles the gameboard
class GameBoard
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

    # horizontal_win?
    # vertical_win?
    # diagonal_win?
  end

  private

  attr_accessor :board, :last
end
