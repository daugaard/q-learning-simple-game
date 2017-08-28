require './game.rb'
require './q_learning_player.rb'

p = QLearningPlayer.new
g = Game.new( p )
p.game = g

100.times do
  g.run
  g.reset
end

p.print_table
puts ""
