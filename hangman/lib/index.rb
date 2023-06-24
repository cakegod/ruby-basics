# frozen_string_literal: true

# Picks a random word from the text file
class WordGenerator
  MIN_WORD_SIZE = 5
  MAX_WORD_SIZE = 12
  attr_reader :text_path

  def initialize(text_path)
    @text_path = text_path
  end

  def random_word
    select_valid_words.sample
  end

  def self.valid_word?(word)
    word.size.between?(MIN_WORD_SIZE, MAX_WORD_SIZE)
  end

  private

  def select_valid_words
    words_list.select { |word| WordGenerator.valid_word?(word) }
  end

  def words_list
    IO.readlines(text_path, chomp: true)
  end
end

# Handles game flow
class Game
  attr_reader :hangman, :player

  def initialize(hangman:, player:)
    @hangman = hangman
    @player = player
    @turns_left = 10
  end

  def start_game
    start_game_loop
  end

  def play_turn
    guess_letter
    decrement_turn
    return Display.turn_info(correct_word: correct_word, type: 'win') if win?
    return Display.turn_info(correct_word: correct_word, type: 'lose') if lose?

    display_turn_info
  end

  private

  def start_game_loop
    loop do
      play_turn
    end
  end

  def display_turn_info
    Display.turns_left(turns_left)
    Display.hangman(hangman_word)
    Display.separator
  end

  def lose?
    turns_left.zero?
  end

  def win?
    hangman.none_masked?
  end

  def guess_letter
    player.guess_letter
  end

  def hangman_word
    hangman.masked_word
  end

  def correct_word
    hangman.word
  end

  def decrement_turn
    self.turns_left -= 1
  end

  attr_accessor :turns_left
end

# Handles player input
class Player
  attr_reader :guessed_letters

  def initialize
    @guessed_letters = []
  end

  def guess_letter
    loop do
      Display.guess_letter

      guess = gets.chomp.downcase
      break guessed_letters << guess if valid_guess?(guess)

      Display.invalid_letter
    end
  end

  def valid_guess?(guess)
    Player.single_letter?(guess) && Player.valid_character?(guess) && not_already_guessed?(guess)
  end

  class << self
    def valid_character?(guess)
      guess.match?(/[A-Za-z]/)
    end

    def single_letter?(guess)
      guess.size == 1
    end
  end

  private

  def not_already_guessed?(guess)
    !guessed_letters.include?(guess)
  end

  attr_writer :guessed_letters
end

# Handles hangman word
class Hangman
  attr_reader :word, :player

  def initialize(word_picker, player)
    @word = word_picker.random_word
    @player = player
    p @word
  end

  def masked_word
    word.split('').map { |letter| guessed_letters.include?(letter) ? letter : '_' }
  end

  def guessed_letters
    player.guessed_letters
  end

  def none_masked?
    masked_word.all? { |letter| letter != '_' }
  end
end

# Handles display
module Display
  def self.separator
    puts '-' * 30
  end

  def self.hangman(word)
    puts "Hangman: #{word.join(' ')}"
  end

  def self.turns_left(turns_left)
    puts "Turns left: #{turns_left}"
  end

  def self.guess_letter
    puts 'Make a guess letter:'
  end

  def self.invalid_letter
    puts 'Invalid letter!'
  end

  def self.turn_info(correct_word:, type:)
    puts "You #{type}! The correct word was: #{correct_word}"
  end
end

new_player = Player.new
hangman = Hangman.new(WordGenerator.new('words.txt'), new_player)
new_game = Game.new(hangman: hangman, player: new_player)
new_game.start_game
