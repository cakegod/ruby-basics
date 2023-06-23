# Used to pick a random word
module WordPicker

  private

  def pick_random_word
    words
      .then(&method(:filter_invalid_words))
      .then(&:sample)
  end

  def words
    IO.readlines('words.txt', chomp: true)
  end

  def filter_invalid_words(words)
    words.filter { |line| line if line.length.between?(5, 12) }
  end
end
