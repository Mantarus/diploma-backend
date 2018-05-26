class Game
  def initialize (player_1, player_2)
    @players= [[player_1, BattleField.new, 0],
               [player_2, BattleField.new, 0]]
    @players.each {|p| reset p}
    @players.shuffle!
    @game_over = false
  end

  def reset p
    print(p[0].name, " game setup\n")
    p[0].reset
    player_ships = p[1].fleet
    if !p[1].place_fleet(p[0].place_strategy player_ships)
      raise "Illegal ship placement"
    else
      puts "Ships placed"
    end
  end

  # Задание 33 start
  def start
    lastshots = []
    while ! @game_over
      p1 = @players[0]
      p2 = @players[1]
      p1[2] += 1
      print("Step #{p1[2]} of player ",p1[0].name, "\n")
      p1[1].cure
      p1[1].move (p1[0].ship_move_strategy p1[1].remains)
      # p2[1].print_field
      shot = p1[0].shot_strategy
      if lastshots.include? shot
        puts "Illegal shot"
        res = "miss"
      else
        lastshots.push shot
        res = p2[1].shoot shot
      end
      print(shot, " ", res, "\n")
      if res == "miss"
        p1[0].miss
        @players.reverse!
        lastshots = []
      else
        p1[0].hit res
        @game_over = p2[1].game_over?
        if @game_over
          puts "Player #{p1[0].name} wins!"
          break
        end
      end
    end
  end
end
# конец описания класса Game
################################################################################

