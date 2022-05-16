require_relative './graphics'

NUM_ROWS = 20
NUM_COLUMNS = 25
BLOCK_SIZE = 14

# actual snake, made up of blocks
class Snake
  def initialize(board)
    @initial_position = [5, 5]
    @board = board
    @x_movement = 0 # snake's x movement/frame
    @y_movement = 0 # snake's y movement/frame
    @body = [@initial_position] # body of the snake
  end
  attr_writer :x_movement, :y_movement
  attr_reader :body, :initial_position

  def move_continuously
    move(@x_movement, @y_movement)
  end

  def move(delta_x, delta_y)
    head = body.last.dup
    @body.shift
    head[0] += delta_x
    head[1] += delta_y
    @body.push head
  end

  def position
    @initial_position
  end
end

# board, on which movement happens,
class Board
  def initialize(game)
    @grid = Array.new(NUM_ROWS) { Array.new(NUM_COLUMNS) }
    @delay = 300 # speed at which the snake traverses 1 block (in miliseconds)
    @game = game
    @snake = Snake.new(self)
    @fruit = [rand(1..NUM_ROWS), rand(1..NUM_COLUMNS)]
    @exists_fruit = false
  end

  attr_accessor :exists_fruit
  attr_reader :delay

  def draw
    @current_pos = @game.draw_body(@snake.body, @current_pos)
  end

  def game_over?
    pos = @snake.initial_position
    if pos[0] < 1 || pos[0] > NUM_COLUMNS || pos[1] < 1 || pos[1] > NUM_ROWS
      true
    else
      false
    end
    # if body parts are not touching
    # body.none? { |part| part[0] == point[0] || part[1] == point[1] }
  end

  def run
    if game_over?
      puts 'game over'
      @game.exit_game
    else
      @snake.move_continuously
    end
    draw
  end

  def change_direction(x_dir, y_dir)
    @snake.x_movement = x_dir
    @snake.y_movement = y_dir
  end

  def ate?
    @snake.body.last[0] = fruit[0] && @snake.body.last[1] = fruit[1]
  end
end

# controls the running of the game, as well as events
# like keybindings
class Game
  def initialize
    @root = SnakeRoot.new
    @timer = SnakeTimer.new
    set_board
    keybindings
    run_game
  end

  # creates the board on which the game is to be rendered
  def set_board
    @canvas = SnakeCanvas.new
    @board = Board.new(self)
    @canvas.place
    @board.draw
  end

  attr_reader :canvas

  def draw_body(body, old = nil)
    draw_fruit

    old.each(&:remove) unless old.nil?
    size = BLOCK_SIZE
    start = body[0]
    body.map do |block|
      SnakeRect.new(@canvas, start[0] * size + block[0] * size + 3, # the +3 and -3 are purely cosmetic
                    start[1] * size + block[1] * size - 3,
                    start[0] * size + size + block[0] * size + 3,
                    start[1] * size + size + block[1] * size - 3,
                    'DarkGreen')
    end
  end

  def draw_fruit
    size = BLOCK_SIZE
    unless @board.exists_fruit
      SnakeRect.new(@canvas, size, # the +3 and -3 are purely cosmetic
                    size,
                    size,
                    size,
                    'red')
      @board.exists_fruit = true
    end
  end

  def run_game
    @timer.stop
    @timer.start(@board.delay, (proc {
      @board.run
      run_game
    }))
  end

  def exit_game
    Tk.exit
  end

  def keybindings
    @root.bind('w', proc { @board.change_direction(0, -1) })
    @root.bind('a', proc { @board.change_direction(-1, 0) })
    @root.bind('s', proc { @board.change_direction(0,  1) })
    @root.bind('d', proc { @board.change_direction(1,  0) })
  end
end
