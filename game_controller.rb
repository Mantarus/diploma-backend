require './array.rb'
require './battlefield.rb'
require './field.rb'
require './game.rb'
require './ship.rb'
require 'FileUtils'

def generate_file_name
  "strategy_#{srand}.rb"
end

def add_module_definition(class_definition, module_name)
  "module #{module_name}\n#{class_definition}\nend"
end

player_str = File.read('player.txt')

class_a_str = player_str
class_b_str = player_str

file_a = generate_file_name
file_b = generate_file_name

module_a = add_module_definition(class_a_str, 'ModuleA')
module_b = add_module_definition(class_b_str, 'ModuleB')

open(file_a, 'w') { |f| f.puts module_a }
open(file_b, 'w') { |f| f.puts module_b }

load file_a
load file_b

FileUtils.remove file_a
FileUtils.remove file_b

srand

p1 = ModuleA::Player.new('Ivan', true)
p2 = ModuleB::Player.new('Feodor')
g = Game.new(p1, p2)
g.start
puts g.read_game_log