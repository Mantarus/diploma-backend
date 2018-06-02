require 'json'

class Response
  attr_accessor :success, :winner, :game_log, :game_error

  def initialize(success, winner, game_log, game_error)
    @success = success
    @winner = winner
    @game_log = game_log
    @game_error = game_error
  end

  def to_s
    "Success: #{@success}\n\n" \
    "Winner: #{@winner}\n\n" \
    "Game log:\n#{@game_log}\n\n" \
    "Error:\n#{@game_error}"
  end

  def to_json
    { success: @success,
      winner: @winner,
      game_log: @game_log,
      game_error: @game_error }.to_json
  end
end