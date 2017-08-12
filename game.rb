require './player.rb'

class Game

  attr_accessor :score, :map_size

  def initialize player
    @run = 0
    @map_size = 12
    @start_position = 3
    @player = player
    reset
  end

  def reset
    @player.x = @start_position
    @cheese_x = 10
    @pit_x = 0
    @score = 0
    @run += 1
  end

  def run
    # Clear the console
    puts "\e[H\e[2J"

    while @score < 10
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
    map_line = "\r##{map_line.join}# | Score #{@score} | Run #{@run}"

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end
