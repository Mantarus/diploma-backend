require 'sinatra'

require './game_controller.rb'

get '/status' do
  'alive'
end

post '/play' do
  body = JSON.parse(request.body.read)
  controller = GameController.new(body['strategy1'], body['strategy2'])
  controller.play_game.to_s
end