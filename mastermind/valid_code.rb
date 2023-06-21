module ValidCode

  private

  def valid_code?(code)
    code.length == VALID_CODE_LENGTH && code.all? { |number| VALID_NUMBERS.include?(number) }
  end

  def print_error_message(code)
    if code.length < VALID_CODE_LENGTH
      puts "Your code: #{code} is too short!"
    elsif code.length > VALID_CODE_LENGTH
      puts "Your code: #{code} is too long!"
    else
      puts "Your code: #{code} contains invalid characters!
      Please use numbers from #{VALID_NUMBERS.first} to #{VALID_NUMBERS.last}."
    end
  end

  def ask_code
    loop do
      puts 'Write your 4-number code!'
      code = gets.chomp.split('').map(&:to_i)
      return code if valid_code?(code)

      print_error_message(code)
    end
  end
end
