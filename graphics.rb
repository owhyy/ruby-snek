require 'tk'

HEIGHT = 600
WIDTH = 800

class SnakeRoot
  def initialize
    @root = TkRoot.new('height' => HEIGHT, 'width' => WIDTH,
                       'background' => 'black') { title 'Snake' }
  end

  # used for cleaning everything
  def restart
    @root.restart
    initialize
  end

  def bind(char, callback)
    @root.bind(char, callback)
  end

  # Necessary so we can unwrap before passing to Tk in some instances.
  attr_reader :root
end

class SnakeTimer
  def initialize
    @timer = TkTimer.new
  end

  def stop
    @timer.stop
  end

  def start(delay, callback)
    @timer.start(delay, callback)
  end
end

class SnakeCanvas
  def initialize
    @canvas = TkCanvas.new('background' => 'gray')
  end

  # def place(height, width, x, y)
  #   @canvas.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  # end

  def place
    @canvas.place('height' => HEIGHT, 'width' => WIDTH, 'x' => 0, 'y' => 0)
  end

  def unplace
    @canvas.unplace
  end

  def delete
    @canvas.delete
  end

  def clear
    unplace
    delete
  end

  # Necessary so we can unwrap before passing to Tk in some instances.
  attr_reader :canvas
end

class SnakeLabel
  def initialize(wrapped_root, &options)
    unwrapped_root = wrapped_root.root
    @label = TkLabel.new(unwrapped_root, &options)
  end

  def place(height, width, x, y)
    @label.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end

  def remove
    @label.remove
  end

  def text(str)
    @label.text(str)
  end
end

class SnakeButton
  def initialize(label, color, &block)
    @button = TkButton.new do
      text label
      background color
      command(proc(&block))
    end
  end

  def place(height, width, x, y)
    @button.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end

  def remove
    @button.unplace
  end
end

class SnakeRect # this is what is used to draw the pieces (the rectangles that build up a piece)
  def initialize(wrapped_canvas, a, b, c, d, color)
    unwrapped_canvas = wrapped_canvas.canvas
    @rect = TkcRectangle.new(unwrapped_canvas, a, b, c, d,
                             'outline' => 'black', 'fill' => color)
  end

  def remove
    @rect.remove
  end

  def move(dx, dy)
    @rect.move(dx, dy)
  end
end

def mainLoop
  Tk.mainloop # this starts everything i guess (renders the root, canvas, buttons and so on)
end

def exitProgram
  Tk.exit # this stops everything
end
