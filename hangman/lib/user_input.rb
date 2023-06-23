# frozen_string_literal: true

# Handles user input
module UserInput
  private

  def pick_choice
    loop do
      puts 'Pick a letter or save your game by typing "save":'
      picked_choice = gets.chomp.downcase
      return picked_choice if valid_letter?(picked_choice)

      puts 'Invalid letter'
    end
  end

  def valid_choice?(picked_choice)
    %w[yes no].include?(picked_choice)
  end

  def valid_letter?(picked_letter)
    picked_letter.length == 1 && picked_letter.match?(/[A-Za-z]/) && !picked_letters.include?(picked_letter)
  end
end
