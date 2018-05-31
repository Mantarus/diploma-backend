require './game_controller.rb'
require 'FileUtils'

# default_player_str = File.read('test_strategies/default.txt')
# custom_player_str = File.read('test_strategies/cannot_compile.txt')

default_player_str = File.read('test_strategies/default.txt')
custom_player_str = File.read('test_strategies/default.txt')

controller = GameController.new(default_player_str, custom_player_str)

game_result = controller.play_game
puts game_result