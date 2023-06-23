# Display
module Display

  private

  def display_lose
    "You lose! The correct word was #{selected_word}"
  end

  def display_win
    "You win! The correct word was #{selected_word}"
  end

  def display_turn_info(picked_letter, picked_letters, hangman)
    separator
    puts "Turn n°#{turn}:"
    puts "You have picked #{picked_letter} this turn"
    puts "Picked letters: #{format_letters(picked_letters)}"
    puts "Hangman: #{format_letters(hangman)}"
    separator
  end

  def format_letters(letters)
    letters.reduce { |acc, curr| acc + " #{curr}" }
  end

  def separator
    puts '-' * 40
  end
end
