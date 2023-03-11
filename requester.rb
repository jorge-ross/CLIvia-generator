module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    options = ["random", "scores", "exit"]
    gets_option(options)
  end

  def will_save?(score)
    score_options = ["y", "n"]
    action = ""
    
    loop do
      puts "Do you want to save your score? (#{score_options.join("/")})"
      print "> "
      action = gets.chomp.strip.downcase
      break if score_options.include?(action)
      
      puts "Invalid option"
    end

    case action
    when "y" then save_score
    when "n" then @score = 0
    end
  end

  # prompt the user to give the score a name if there is no name given, set it as Anonymous
  def save_score
    puts "Type the name to assign to the score"
    print "> "
    name = gets.chomp
    name = "Anonymous" if name.empty?
    data = { score: @score, name: name }
    save(data)
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
