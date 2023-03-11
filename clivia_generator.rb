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
    print_welcome
    action = select_main_menu_action

    until action == "exit"
      case action
      when "random" then random_trivia
      when "scores" then parse_scores
      end
      print_welcome
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
    @answers = questions[:incorrect_answers].push(questions[:correct_answer]).shuffle!
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
    File.write(@filename, JSON.pretty_generate(@records))
    @score = 0
  end

  def parse_scores
    scores_file = "scores.json"

    begin
      parsed_scores = JSON.parse(File.read(scores_file))
    rescue Errno::ENOENT
      parsed_scores = []
    end

    print_scores(parsed_scores)
  end

  def load_questions
    @questions = Clivia.gets_trivia[:results]
  end

  def print_scores(parsed_scores)
    table = Terminal::Table.new do |t|
      t.title = "Top Scores"
      t.headings = ["Name", "Score"]
      parsed_scores.sort_by { |s| s["score"] }.reverse.each do |a|
        t.add_row [a["name"], a["score"]]
      end
    end

    puts table
  end
end
