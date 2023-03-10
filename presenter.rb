module Presenter
  def print_welcome
    puts [
      "#" * 40,
      "#     Welcome to CLIvia Generator     #",
      "#" * 40
    ]
  end

  def print_score
    puts "Well done! Your score is #{@score}"
  end
end
