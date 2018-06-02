require 'FileUtils'
require 'json'

require './request.rb'

default_player_str = File.read('test_strategies/default.txt')
custom_player_str = File.read('test_strategies/no_method.txt')

request = Request.new('Player 1', default_player_str, 'Player 2', custom_player_str)

json_str = request.to_json

puts json_str