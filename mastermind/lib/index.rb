# frozen_string_literal: true

require 'yaml'

# Picks a random word from the text file
class WordPicker
  MIN_WORD_SIZE = 5
  MAX_WORD_SIZE = 12
  attr_reader :text_path

  def initialize(text_path)
    @text_path = text_path
  end

  def random_word
    IO.readlines(text_path, chomp: true)
      .then(&method(:valid_words))
      .then(&:sample)
  end

  private

  def valid_words(words)
    words.select(&method(:valid_size?))
  end

  def valid_size?(words)
    words.size.between?(MIN_WORD_SIZE, MAX_WORD_SIZE)
  end
end

# Handles game flow
class Game
  attr_reader :hangman, :player

  def initialize(hangman:, player:)
    @hangman = hangman
    @player = player
  end

  def start_game_loop
    game_turn until win? || lose?
    game_summary
  end

  def save_game
    File.open('save.yaml', 'w') { |file| file.write(YAML.dump(self)) }
  end

  def self.load_game
    YAML.safe_load(File.read('save.yaml'))
  end

  private

  def game_turn
    Display.ask_guess_info
    player.guess_letter
    Display.turn_info(tries_left: player.tries_left, masked_word: hangman.masked_word)
    Display.ask_save_game
    save_game if player.request_save_input == 'yes'
  end

  def lose?
    player.out_of_turns?
  end

  def win?
    hangman.no_letters_masked?
  end

  def game_summary
    if win?
      Display.win_info(hangman.word)
    else
      Display.lose_info(hangman.word)
    end
  end
end

# Handles player input
class Player
  TRIES_PER_GAME = 10
  attr_reader :guessed_letters

  def initialize
    @guessed_letters = []
  end

  def guess_letter
    guess = request_letter_input
    guessed_letters << guess unless already_guessed?(guess)
  end

  def request_letter_input
    loop do
      input = gets.chomp.downcase
      return input if single_letter?(input) && valid_character?(input)
    end
  end

  def yes_or_no?(input)
    %w[yes no].include?(input)
  end

  def request_save_input
    loop do
      input = gets.chomp.downcase
      return input if valid_character?(input) && yes_or_no?(input)
    end
  end

  def valid_character?(input)
    input.match?(/[A-Za-z]/)
  end

  def single_letter?(input)
    input.size == 1
  end

  def already_guessed?(guess)
    guessed_letters.include?(guess)
  end

  def tries_left
    TRIES_PER_GAME - guessed_letters.size
  end

  def out_of_turns?
    tries_left.zero?
  end

  def include_letter?(letter)
    guessed_letters.include?(letter)
  end
end

# Handles hangman word
class Hangman
  attr_reader :word, :player

  def initialize(word, player)
    @word = word
    @player = player
  end

  def masked_word
    word.split('').map { |letter| player.include_letter?(letter) ? letter : '_' }
  end

  def no_letters_masked?
    masked_word.none? { |letter| letter == '_' }
  end
end

# Handles display
module Display
  def self.turn_info(tries_left:, masked_word:)
    puts "Turns left: #{tries_left}"
    puts "Hangman: #{masked_word.join(' ')}"
    separator
  end

  def self.win_info(word)
    puts "You win! The correct word was: #{word}"
  end

  def self.lose_info(word)
    puts "You lose! The correct word was: #{word}"
  end

  def self.ask_guess_info
    puts 'Guess the letter!'
  end

  def self.separator
    puts '-' * 30
  end

  def self.ask_load_game
    puts 'Load existing save? Type YES or NO.'
  end

  def self.ask_save_game
    puts 'Save? Type YES or NO.'
  end
end

def start_game
  Display.ask_load_game
  user_choice = gets.chomp

  if user_choice == 'YES'
    Game.load_game
    return
  end

  new_player = Player.new
  word_generator = WordPicker.new('words.txt')
  hangman = Hangman.new(word_generator.random_word, new_player)
  Game.new(hangman: hangman, player: new_player).start_game_loop
end

start_game
