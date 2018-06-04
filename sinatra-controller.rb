require 'sinatra'
require 'timeout'

require './game_controller.rb'

get '/status' do
  'alive'
end

post '/play' do
  body = JSON.parse(request.body.read)
  controller = GameController.new(body['strategy1'], body['strategy2'])
  begin
    result = Timeout::timeout(2) do
      result = controller.play_game
    end
  rescue Timeout::Error
    result = Response.new(false, nil, nil, 'Timed out!')
  rescue NoMemoryError
    result = Response.new(false, nil, nil, 'Too much memory!')
  end
  puts result.game_error
  result.to_json
end