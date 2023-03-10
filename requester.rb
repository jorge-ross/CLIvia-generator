module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    options = ["random", "scores", "exit"]
    gets_option(options)
  end

  def ask_question(question)
    # show category and difficulty from question
    # show the question
    # show each one of the options
    # grab user input
  end

  def will_save?(score)
    # show user's score
    # ask the user to save the score
    # grab user input
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end

  def gets_option(options)
    input = ""

    loop do
      puts options.join(" | ")
      print "> "
      input = gets.chomp
      break if options.include?(input)

      puts "Invalid option"
    end

    input
    # keep going until the user gives a valid option
  end

  def gets_number(valid)
    print "> "
    selection = gets.chomp.to_i

    until selection < valid && selection.positive?
      puts "Invalid answer"
      print "> "
      selection = gets.chomp.to_i
    end

    selection
  end
end
