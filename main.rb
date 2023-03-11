require_relative "clivia_generator"

# capture command line arguments (ARGV)
# if ARGV[0]
#   @filename = ARGV[0]
# end

trivia = CliviaGenerator.new
trivia.start
