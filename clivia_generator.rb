# do not forget to require your gem dependencies
require "htmlentities"
require_relative "presenter"
require_relative "requester"
require_relative "services"

class CliviaGenerator
  include Presenter
  include Requester

  def initialize
    @filename = ARGV[0] || "scores.json"
    @questions = []
    @score = 0
    @html_entities = HTMLEntities.new
    # we need to initialize a couple of properties here
  end

  def start
    # welcome message
    print_welcome
    action = select_main_menu_action

    until action == "exit"
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      end

      # print_welcome
      action = select_main_menu_action
    end
    # prompt the user for an action
    # keep going until the user types exit
  end

  def random_trivia
    load_questions.each do |questions|
      puts "Category: #{@html_entities.decode(questions[:category])} | Difficulty: #{@html_entities.decode(questions[:difficulty])}"
      ask_questions(questions)
      puts "\n"
    end
  end

  def ask_questions(questions)
    # ask each question
    player_answer = ""
    correct_answer_index = 0

    puts "Question: #{@html_entities.decode(questions[:question])}"
    @answers = questions[:incorrect_answers] << (questions[:correct_answer]) #mix missing
    @answers.each_with_index.map do |answer, index|
      puts "#{index + 1}. #{@html_entities.decode(answer)}"
      correct_answer_index = index + 1 if answer == questions[:correct_answer]
    end

    player_selection = gets_number(questions[:incorrect_answers].length + 1)
    player_answer = @answers.select { |answer| answer == player_selection - 1 }.first

    # if response is correct, put a correct message and increase score
    if player_selection == correct_answer_index
      puts "#{@html_entities.decode(player_answer)}... Correct"
      @score += 10
    else
      puts "#{@html_entities.decode(player_answer)}... Incorrect"
      puts "The correct answer was: #{@html_entities.decode(questions[:correct_answer])}"
    end

    
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    @questions = Clivia.gets_trivia[:results]
    # ask the api for a random set of questions
    # then parse the questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    puts "here are the scores"
    # print the scores sorted from top to bottom
  end
end
