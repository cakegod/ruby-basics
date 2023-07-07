# frozen_string_literal: true

# The game-board
class GameBoard
  attr_reader :win_combinations, :board

  def initialize(board = Array.new(9, nil))
    @board = board
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

  def find_win_combination(marker)
    win_combinations.find do |combination|
      combination.all? { |index| @board[index].eql?(marker) }
    end
  end

  def valid_position?(position)
    position.between?(0, 8)
  end

  def place_marker(position, marker)
    raise ArgumentError, 'Invalid position' unless valid_position?(position)

    @board[position] = marker
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

# Manages players
class PlayersManager
  def initialize(human_player: Player.new('X'), computer_player: Player.new('O'))
    @human_player = human_player
    @computer_player = computer_player
    @current_player = @human_player
  end

  def swap_player
    self.current_player = current_player == human_player ? computer_player : human_player
  end

  def current_player_marker
    current_player.marker
  end

  private

  attr_reader :human_player, :computer_player
  attr_accessor :current_player
end

# Game
class Game
  attr_reader :current_player, :board, :players_manager

  def initialize(players_manager: PlayersManager.new, input: -> { gets })
    @board = GameBoard.new
    @players_manager = players_manager
    @game_over = false
    @input = input
  end

  def game_loop
    until game_over
      puts "#{players_manager.current_player_marker} pick a position!"
      play_turn
    end
  end

  private

  def play_turn
    index = @input.call.to_i

    if index.between?(0, 8)
      board.place_marker(index, players_manager.current_player_marker)
    else
      puts 'Invalid choice, pick again:'
    end

    process_turn_result
  end

  def process_turn_result
    marker = players_manager.current_player_marker
    win_combination = board.find_win_combination(marker)

    if win_combination
      puts "Player #{marker} wins at #{win_combination}!"
      self.game_over = true
    end

    puts board.see_board
    players_manager.swap_player
  end

  attr_reader :human_player, :computer_player
  attr_writer :current_player
  attr_accessor :game_over
end

# players_manager = PlayersManager.new(human_player: Player.new('X'), computer_player: Player.new('O'))
# game = Game.new(players_manager)
# game.game_loop

