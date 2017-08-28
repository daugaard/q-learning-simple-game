class Game
  attr_accessor :score, :map_size_x, :map_size_y, :cheese_x, :cheese_y
  def initialize player
    @run = 0
    @map_size_x = 10
    @map_size_y = 10
    @start_position = [3,3]
    @player = player
    reset

    # Clear the console
    puts "\e[H\e[2J"

  end

  def reset
    @player.x = @start_position[0]
    @player.y = @start_position[1]
    @cheese_x = rand(@map_size_x)
    @cheese_y = rand(@map_size_y)
    @pit_x = 5
    @pit_y = 4
    @score = 0
    @run += 1
    @moves = 0
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

  end

  def gameloop
    move = @player.get_input
    if move == :left
      @player.x = @player.x > 0 ? @player.x-1 : @player.x;
    elsif move == :right
      @player.x = @player.x < @map_size_x-1 ? @player.x+1 : @player.x;
    elsif move == :down
      @player.y = @player.y < @map_size_y-1 ? @player.y+1 : @player.y;
    elsif move == :up
      @player.y = @player.y > 0 ? @player.y-1 : @player.y;
    end

    if @player.x == @cheese_x && @player.y == @cheese_y
      @score += 1
      @cheese_x = rand(@map_size_x)
      @cheese_y = rand(@map_size_y)
    end

    if @player.x == @pit_x && @player.y == @pit_y
      @score -= 1
      @player.x = @start_position[0]
      @player.y = @start_position[1]
    end
  end

  def draw
    # Clear the console
    #puts "\e[H\e[2J"
    puts ""

    puts "Score #{@score} | Run #{@run}\n"
    puts "############"
    # Compute map line
    @map_size_y.times.each do |y|
      map_line = @map_size_x.times.map do |x|
        if @player.x == x && @player.y == y
          'P'
        elsif @cheese_x == x && @cheese_y == y
          'C'
        elsif @pit_x == x && @pit_y == y
          'O'
        else
          '='
        end
      end
      # Draw to console
      puts "##{map_line.join}#"
    end
    puts "############"
  end

end
