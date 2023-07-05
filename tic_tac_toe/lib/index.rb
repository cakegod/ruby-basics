# frozen_string_literal: true

# The game-board
class Board
  attr_reader :win_combinations, :board

  def initialize
    @board = Array.new(9, nil)
    @win_combinations =
      [[0, 1, 2],
       [3, 4, 5],
       [6, 7, 8],
       [0, 3, 6],
       [1, 4, 7],
       [2, 5, 8],
       [0, 4, 8],
       [6, 4, 2]]
  end

  def check_win(marker)
    win_combinations.find do |combination|
      combination.all? { |index| @board[index].eql?(marker) }
    end
  end

  def place_marker(index, marker)
    @board[index] = marker
  end

  def see_board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} "
    puts '-----------'
    puts " #{@board[3]} | #{@board[4]} | #{@board[5]} "
    puts '-----------'
    puts " #{@board[6]} | #{@board[7]} | #{@board[8]} "
  end
end

# A player
class Player
  def initialize(marker)
    @marker = marker
  end

  attr_reader :marker
end

# Game
class Game
  attr_reader :current_player, :board

  def initialize
    @board = Board.new
    @human_player = Player.new('x')
    @computer_player = Player.new('o')
    @current_player = @human_player
    @is_game_over = false
  end

  def game_loop
    until max_turn_reached?
      puts "#{current_player.marker} pick a position!"
      play_turn(gets.to_i)
    end
  end

  private

  def play_turn(index)
    if index.between?(0, 8)
      board.place_marker(index, current_player.marker)
    else
      puts 'Invalid choice, pick again:'
    end

    board.place_marker(index, current_player.marker)
    process_turn_result
  end

  def max_turn_reached?
    is_game_over
  end

  def swap_player
    self.current_player = current_player == human_player ? computer_player : human_player
  end

  def process_turn_result
    win = board.check_win(current_player.marker)

    if win.nil?
      puts board.see_board
      swap_player
    else
      puts "Player #{current_player.marker} wins at #{win}!"
      self.is_game_over = true
    end
  end

  attr_reader :human_player, :computer_player
  attr_writer :current_player
  attr_accessor :is_game_over
end

#
# game = Game.new
#
# until game.max_turn_reached?
#   puts "#{game.current_player.marker} pick a position!"
#   game.play_turn(gets.to_i)
# end
