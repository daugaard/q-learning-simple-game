require './game.rb'
require './player.rb'

p = Player.new
g = Game.new( p )
g.run
