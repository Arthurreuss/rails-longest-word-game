require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def score
    @end_time = Time.now
    @word = params['word'].upcase
    @letters = @@letters
    @start_time = @@start_time
    @score = compute_score(@start_time, @end_time, @word)
    if letter_included?(@word, @letters)
      if english_word?(@word)
        @result = [@score, "well done"]
      else
        @result = [0, "not an english word"]
      end
    else
      @result = [0, "not in the grid"]
    end
  end

  def new
    # @letters = []
    @@letters = ("A".."Z").to_a.sample(10)
    @letters = @@letters
    @@start_time = Time.now
  end

  def letter_included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(start_time, end_time, word)
    time = end_time - start_time
    time > 60.0 ? 0 : word.size * (1.0 - (time / 60.0))
  end
end
