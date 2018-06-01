require 'json'

class Request
  attr_accessor :strategy1, :strategy2, :player1, :player2

  def initialize(p1, strat1, p2, strat2)
    @player1 = p1
    @strategy1 = strat1
    @player2 = p2
    @strategy2 = strat2
  end

  def to_json
    { player1: @player1, strategy1: @strategy1,
      player2: @player1, strategy2: @strategy1 }.to_json
  end
end