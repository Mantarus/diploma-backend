require './response.rb'
require './game_controller.rb'

require 'FileUtils'
require 'timeout'

default_player_str = File.read('test_strategies/default.txt')
custom_player_str = File.read('test_strategies/default.txt')

controller = GameController.new(default_player_str, custom_player_str)

begin
  game_result = Timeout::timeout(1000000000) do
    game_result = controller.play_game
  end
rescue Timeout::Error
  game_result = Response.new(false, nil, nil, 'Timed out!')
end
puts game_result