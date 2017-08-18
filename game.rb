class Game
  attr_accessor :score, :map_size
  def initialize player
    initialize_start_position
    @run = 0
    @map_size = 12
    @player = player
    reset

    # Clear the console
    puts "\e[H\e[2J"

  end

  def reset
    @score = 0
    @run += 1
    @moves = 0
    generate_start_positions
  end

  def initialize_start_position
    @start_position = 0
    @cheese_x = 0
    @pit_x = 0
  end

  def generate_start_positions
    while @start_position == @cheese_x || @start_position == @pit_x
      @start_position = rand(@map_size - 1)
    end

    @cheese_x = @start_position
    while @cheese_x == @start_position || @cheese_x == @pit_x
      @cheese_x = rand(@map_size - 1)
    end

    @pit_x = @start_position
    while @pit_x == @start_position || @pit_x == @cheese_x
      @pit_x = rand(@map_size - 1)
    end
  end

  def run
    while @score < 5 && @score > -5
      draw
      gameloop
      @moves += 1
    end

    # Draw one last time to update the
    draw

    if @score >= 5
      puts "  You win in #{@moves} moves!"
    else
      puts "  Game over"
    end

    initialize_start_position
  end

  def gameloop
    move = @player.get_input
    if move == :left
      @player.x = @player.x > 0 ? @player.x-1 : @map_size-1;
    elsif move == :right
      @player.x = @player.x < @map_size-1 ? @player.x+1 : 0;
    end

    if @player.x == @cheese_x
      @score += 1
      @player.x = @start_position
    end

    if @player.x == @pit_x
      @score -= 1
      @player.x = @start_position
    end
  end

  def draw
    # Compute map line
    map_line = @map_size.times.map do |i|
      if @player.x == i
        'P'
      elsif @cheese_x == i
        'C'
      elsif @pit_x == i
        'O'
      else
        '='
      end
    end
    map_line = "\r##{map_line.join}# | Score #{@score} | Run #{@run}"

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end
