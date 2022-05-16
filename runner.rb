require_relative './snek'

def run_game
  Game.new  # initilalizes new game object
  mainLoop   # calls the mainLoop
end

if ARGV.count > 0
  if ARGV[0] == 'run'
    run_game
  else
    puts 'usage: runner run'
  end
end
