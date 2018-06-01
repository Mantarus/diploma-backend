require './game_controller.rb'
require 'FileUtils'
require 'timeout'

# default_player_str = File.read('test_strategies/default.txt')
# custom_player_str = File.read('test_strategies/cannot_compile.txt')

default_player_str = File.read('test_strategies/default.txt')
custom_player_str = File.read('test_strategies/default.txt')

controller = GameController.new(default_player_str, custom_player_str)

begin
  game_result = Timeout::timeout(2) do
    game_result = controller.play_game
  end
  puts game_result
rescue Timeout::Error
  puts 'Calculation timed out'
end
