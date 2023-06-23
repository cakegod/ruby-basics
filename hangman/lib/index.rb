# frozen_string_literal: true

require_relative 'user_input'
require_relative 'display'
require_relative 'word_picker'
require 'yaml'

# Manages game save
class SaveManager
  class << self
    def load_game
      File.open('game_save.yaml', 'r') if File.exist?('game_save.yaml') do |f|
        YAML.safe_load(f, permitted_classes: [Game])
      end
    end

    def save_game(game)
      File.open('game_save.yaml', 'w') { |file| file.write(YAML.dump(game)) }
    end
  end
end

# Game handler
class Game
  include UserInput
  include Display
  include WordPicker

  def initialize
    @selected_word = pick_random_word
    @picked_letters = []
    @turn = 0
  end

  def start_game
    play_turn until game_won? || game_lost?
    puts game_won? ? display_win : display_lose
  end

  private

  def game_lost?
    max_turn_reached?
  end

  def game_won?
    all_letters_found?
  end

  def all_letters_found?
    hangman.all? { |letter| letter != '_' }
  end

  def play_turn
    picked_choice = pick_choice
    return SaveManager.save_game(self) if picked_choice == 'save'

    picked_letters << pick_choice
    increment_turn
    display_turn_info(picked_letters.last, picked_letters, hangman)
  end

  def max_turn_reached?
    turn == 25
  end

  def increment_turn
    self.turn += 1
  end

  def hangman
    selected_word.split('').map { |letter| picked_letters.include?(letter) ? letter : '_' }
  end

  attr_reader :selected_word, :picked_letters
  attr_accessor :turn
end

loaded_game = SaveManager.load_game
if loaded_game.instance_of?(Game)
  loaded_game.start_game
else
  Game.new.start_game
end
