require 'open-uri'

# rails generate controller games
class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    session[:score] = 0 if session[:score].nil?
    @score = 0
    @letters = params[:letters].split
    @word = params[:word].upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    if included?(@word, @letters) == false
      @message = "Sorry but #{@word} c an't be built out of #{@letters}"
    elsif included?(@word, @letters) == true && english_word?(@word) == false
      @message = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{@word} is a valid English word!"
      @score += params[:word].length
      session[:score] += @score
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
