require './game.rb'
require './q_learning_player.rb'

p = QLearningPlayer.new
g = Game.new( p )
p.game = g

3.times do
  g.run
  g.reset
end

puts ""
