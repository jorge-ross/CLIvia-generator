# do not forget to require your gem dependencies
require "htmlentities"
require "json"
require "terminal-table"
require_relative "presenter"
require_relative "requester"
require_relative "services"

class CliviaGenerator
  include Presenter
  include Requester

  def initialize
    @filename = "scores.json"
    @questions = []
    @score = 0    
    @html_e = HTMLEntities.new
    @records = []
  end

  def start
    begin
      File.open(@filename, "r") do |file|
        @records = JSON.parse(file.read)
      end
    rescue Errno::ENOENT
    end
    # welcome message
    print_welcome
    action = select_main_menu_action

    until action == "exit"
      case action
      when "random" then random_trivia
      when "scores" then parse_scores
      end
      # print_welcome
      action = select_main_menu_action
    end
    # prompt the user for an action
    # keep going until the user types exit
  end

  def random_trivia
    load_questions.each do |questions|
      puts "Category: #{@html_e.decode(questions[:category])} | Difficulty: #{@html_e.decode(questions[:difficulty])}"
      ask_questions(questions)
      puts "\n"
    end
    print_score
    puts "-" * 40
    will_save?(@score)
  end

  def ask_questions(questions)
    # ask each question
    correct_answer_index = 0

    puts "Question: #{@html_e.decode(questions[:question])}"
    @answers = questions[:incorrect_answers].concat([questions[:correct_answer]]).shuffle!
    @answers.each_with_index.map do |answer, index|
      puts "#{index + 1}. #{@html_e.decode(answer)}"
      correct_answer_index = index + 1 if answer == questions[:correct_answer]
    end

    player_answer = gets_number(questions[:incorrect_answers].length + 1)
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    if player_answer == correct_answer_index
      puts "#{@html_e.decode(player_answer)}... Correct"
      @score += 10
    else
      puts "#{@html_e.decode(player_answer)}... Incorrect"
      puts "The correct answer was: #{@html_e.decode(questions[:correct_answer])}"
    end

    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    @records << data
    File.open(@filename, "w") do |file|
      file.write(JSON.pretty_generate(@records))
    end
    @score = 0
  end

  def parse_scores
    parsed_scores = File.open(@filename, "r")
    scores = []
    parsed_scores.each_line do |line|
      name, score = line.split(",")
      scores << { name: name, score: score.to_i }
    end
    print_scores(scores)
  end

  def load_questions
    @questions = Clivia.gets_trivia[:results]
  end

  def print_scores(scores)
    
    sorted_scores = scores.sort_by { |s| s[:score] }.reverse
    p sorted_scores

    table = Terminal::Table.new do |t|
    t.title = "Top Scores"
    t.headings = ["Name", "Score"]
    end

    
    sorted_scores.each do |score|
      table.add_row [score[:name], score[:score]]
    end

    puts table
    # print the scores sorted from top to bottom
  end
end
