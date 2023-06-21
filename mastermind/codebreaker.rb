# frozen_string_literal: true

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
