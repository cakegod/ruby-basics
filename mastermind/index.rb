# frozen_string_literal: true

require_relative 'valid_code'
require_relative 'codemaker'
require_relative 'codebreaker'

VALID_CODE_LENGTH = 4
VALID_NUMBERS = (0..6).freeze

# Generate a random code
module RandomCode
  def generate_random_code
    Array.new(VALID_CODE_LENGTH) { rand(VALID_NUMBERS).to_i }
  end
end

def separate
  puts '--------------'
end

# Game
class Game
  HUMAN_CODEMAKER = 1
  HUMAN_CODEBREAKER = 2
  MAX_TURNS = 12

  def initialize
    @turn = 0
    @game_over = false
  end

  def start_game
    assign_choices
    start_game
  end

  private

  def start_game
    play_turn until max_turn_reached?
  end

  def increment_turn
    self.turn += 1
  end

  def clues_all_black?(clues)
    clues.length == 4 && clues.all? { |clue| clue == 'black' }
  end

  def play_turn
    guess = codebreaker.code
    clues = codemaker.give_clues(guess)
    if clues_all_black?(clues)
      self.game_over = true
      return puts "You win at turn n°#{turn}! The code was #{guess}."
    end

    increment_turn
    print_turn_result(guess, clues)
  end

  def print_turn_result(guess, clues)
    puts "Turn n°#{turn}:"
    puts "You've picked #{guess}"
    puts "Your clues are: #{clues}"
    separate
  end

  def max_turn_reached?
    turn == MAX_TURNS || game_over
  end

  def assign_choices
    if pick_choice == HUMAN_CODEMAKER
      self.codemaker = HumanCodeMaker.new
      self.codebreaker = ComputerCodeBreaker.new
    else
      self.codemaker = ComputerCodeMaker.new
      self.codebreaker = HumanCodeBreaker.new
    end
  end

  def pick_choice
    loop do
      puts 'Welcome to MASTERMIND, type 1 to be the codebreaker, 2 to be the codemaker:'
      choice = gets.chomp.to_i
      return choice if valid_choice(choice)

      print_error_message(choice)
    end
  end

  def valid_choice(choice)
    [HUMAN_CODEMAKER, HUMAN_CODEBREAKER].include?(choice)
  end

  def print_error_message(choice)
    puts "Your choice: #{choice} is not valid."
  end

  attr_accessor :codemaker, :codebreaker, :turn, :game_over
end

Game.new.start_game
