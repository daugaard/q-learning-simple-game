require './player.rb'

class Game
  def initialize player
    @map_size = 12
    @start_position = 3
    @player = player
    @player.x = @start_position
    @cheese_x = 10
    @pit_x = 0
    @score = 0
  end

  def run
    # Clear the console
    puts "\e[H\e[2J"

    while true
      draw
      gameloop
    end
  end

  def gameloop
    move = @player.get_input
    if move == :left
      @player.x = @player.x > 0 ? @player.x-1 : @map_size-1;
    elsif move == :right
      @player.x = @player.x < @map_size ? @player.x+1 : 0;
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
    map_line = "\r##{map_line.join}# | Score #{@score}   "

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end

g = Game.new( Player.new )
g.run
