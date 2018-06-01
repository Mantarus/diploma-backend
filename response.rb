class Response
  attr_accessor :success, :game_log, :game_error

  def initialize(success, game_log, game_error)
    @success = success
    @game_log = game_log
    @game_error = game_error
  end

  def to_s
    "Success: #{@success}\n\nGame log:\n#{@game_log}\n\nError:\n#{@game_error}"
  end
end