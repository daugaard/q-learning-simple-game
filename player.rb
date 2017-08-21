require 'io/console'

class Player
  attr_accessor :x

  def initialize
    @x = 0
  end

  def to_s
    '😃'
  end

  def get_input
    input = STDIN.getch
    if input == 'a'
      return :left
    elsif input == 'd'
      return :right
    elsif input == 'q'
      exit
    end

    return :nothing
  end
end
