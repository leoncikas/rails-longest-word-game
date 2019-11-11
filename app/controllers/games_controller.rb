require 'open-uri'
require 'JSON'

class GamesController < ApplicationController
  def new
    @number = rand(3..15)
    @letters = []
    @alphabet = ('A'..'Z').to_a
    @number.times { @letters << @alphabet[rand(@alphabet.size)].to_s }
    @letters
  end

  def score
    @word = params[:longest_word]
    @grid = params[:grid]
    if included?(@word, @grid)
      if english?(@word)
        @points = points2(@word, @grid)
        @result = "Congratulations word is English and in the grid. Score #{@points} points"
      else
        @result = "Word is not English. Score 0 points"
      end
    else
      @result = "Word is not in the grid! Score 0 points"
    end
  end

  def included?(word, grid)
    word.split('').all? { |letter| grid.include? letter }
  end

  def english?(word)
    answer = open("https://wagon-dictionary.herokuapp.com/#{word.downcase}")
    answer = JSON.parse(answer.read.to_s)
    answer['found']
  end

  def points2(word, grid)
    (word.length * 10 - ((grid.length - word.length) * 2))
  end
end
