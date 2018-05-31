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

def handle_syntax_error(syntax_error, file)
  FileUtils.remove file
  puts syntax_error.message
end

default_player_str = File.read('test_strategies/default.txt')
custom_player_str = File.read('test_strategies/cannot_compile.txt')

class_a_str = default_player_str
class_b_str = custom_player_str

file_a = generate_file_name
file_b = generate_file_name

module_a = add_module_definition(class_a_str, 'ModuleA')
module_b = add_module_definition(class_b_str, 'ModuleB')

open(file_a, 'w') { |f| f.puts module_a }
open(file_b, 'w') { |f| f.puts module_b }

begin
load file_a
rescue SyntaxError => error
  handle_syntax_error(error, file_a)
  FileUtils.remove file_b
  return
end

begin
  load file_b
rescue SyntaxError => error
  handle_syntax_error(error, file_b)
  FileUtils.remove file_a
  return
end

FileUtils.remove file_a
FileUtils.remove file_b

srand

begin
  p1 = ModuleA::Player.new('Player 1')
  p2 = ModuleB::Player.new('Player 2')
  g = Game.new(p1, p2)
  g.start
  # puts g.read_game_log
rescue => error
  puts error.message
end