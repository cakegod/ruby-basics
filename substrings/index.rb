# frozen_string_literal: true

def substrings(words, dictionary)
  dictionary.each_with_object(Hash.new(0)) do |string, hash|
    count = words.split.count { |word| word.downcase.include?(string) }
    hash[string] = count unless count.zero?
  end
end