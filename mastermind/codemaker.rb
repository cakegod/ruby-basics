# frozen_string_literal: true

require_relative 'valid_code'

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

# computer code make
class ComputerCodeMaker < CodeMaker
  def initialize
    super(generate_random_code)
  end

  include RandomCode
end
