require './array.rb'
require './battlefield.rb'
require './field.rb'
require './game.rb'
require './player.rb'
require './ship.rb'

srand

p1 = Player.new('Ivan', true)
p2 = Player.new('Feodor')
g = Game.new(p1,p2)
g.start

class Integer
  def to_ii
    a = self.to_s
    (a + a).to_i
  end
end

# a = Field.new
# b = Ship.new(a, 4)
# b.set!(4,4,true)
# a.print_field
# b.rotate(2,1)
# a.print_field
# b.rotate(3,1)
# a.print_field
# b.rotate(1,3)
# a.print_field
# b.rotate(4,3)
# a.print_field
# b.rotate(4,2)
# a.print_field
# b.rotate(3,2)
# a.print_field
# b.rotate(3,2)
# a.print_field
# b.rotate(4,3)
# a.print_field
# b.rotate(4,3)
# a.print_field

# a = BattleField.new
# a.place_fleet([[0,1,1,true],
#                [1,7,0,false],
#                [2,7,9,true],
#                [3,1,4,false],
#                [4,6,4,true],
#                [5,3,8,true],
#                [6,3,3,true],
#                [7,3,5,false],
#                [8,1,8,true],
#                [9,8,6,true]])
# a.print_field

# a = BattleField.new
# a.place_fleet([[0,1,1,true],
#                [1,7,0,false],
#                [3,1,4,false],
#                [4,6,4,true],
#                [6,3,3,true],
#                [8,1,8,true],
#                [9,8,6,true]])
# a.print_field