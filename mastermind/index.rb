# frozen_string_literal: true

require_relative 'valid_code'
VALID_CODE_LENGTH = 4
VALID_NUMBERS = (0..6).freeze

# Generate a random code
module RandomCode
  def generate_random_code
    Array.new(VALID_CODE_LENGTH) { rand(VALID_NUMBERS).to_i }
  end
end

# Codemaker for mastermind
class CodeMaker
  def initialize(code)
    @code = code
    p code
  end

  def give_clues(guess)
    white_pegs(black_pegs(guess))
  end

  private

  def black_pegs(guess)
    guess.each_with_index.map { |number, i| exact_code_match?(number, i) ? 'black' : number }
  end

  def white_pegs(white_pegs)
    code_clone = code.clone

    white_pegs.each_with_index.each_with_object([]) do |(number, i), acc|
      if partial_code_match?(number, code_clone)
        acc << 'white'
        code_clone[i] = nil
      end
      acc << 'black' if number == 'black'
    end
  end

  def exact_code_match?(number, index)
    number == code[index]
  end

  def partial_code_match?(number, code_clone)
    code_clone.include?(number)
  end

  attr_accessor :code
end

# Human maker
class HumanCodeMaker < CodeMaker
  include ValidCode

  def initialize
    super(ask_code)
  end
end

# computer code maker
class ComputerCodeMaker < CodeMaker
  def initialize
    super(generate_random_code)
  end

  include RandomCode
end

def separate
  puts '--------------'
end

# Base codebreaker
class CodeBreaker
  def code
    raise NotImplementedError, 'Not implemented'
  end
end

# Codebreaker
class HumanCodeBreaker < CodeBreaker
  def code
    ask_code
  end

  include ValidCode
end

# Codebreaker
class ComputerCodeBreaker < CodeBreaker
  def code
    generate_random_code
  end

  include RandomCode
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
    play_game
  end

  private

  def play_game
    play_turn until game_over?
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

  def game_over?
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
