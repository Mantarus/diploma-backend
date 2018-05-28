# class Game
class Game
  def initialize(player1, player2)
    @players = [
      [player1, BattleField.new, 0],
      [player2, BattleField.new, 0]
    ]
    @players.each { |p| reset p }
    @players.shuffle!
    @game_over = false
  end

  def reset(player_arr)
    print(player_arr[0].name, " game setup\n")
    player_arr[0].reset
    player_ships = player_arr[1].fleet
    if !player_arr[1].place_fleet(player_arr[0].place_strategy(player_ships))
      raise 'Illegal ship placement'
    else
      puts 'Ships placed'
    end
  end

  def start
    last_shots = []
    until @game_over

      # Init players
      p1 = @players[0]
      p2 = @players[1]

      # Increase turn counter
      p1[2] += 1
      print("Step #{p1[2]} of player ", p1[0].name, "\n")

      # Cure all current player's ships
      p1[1].cure

      # Player moves or rotates one of his ships and then shoots
      p1[1].move(p1[0].ship_move_strategy(p1[1].remains))
      # p2[1].print_field
      shot = p1[0].shot_strategy

      # Check for illegal shot and, if legal, make a shot
      if last_shots.include? shot
        puts 'Illegal shot'
        res = 'miss'
      else
        last_shots.push shot
        res = p2[1].shoot shot
      end

      print(shot, ' ', res, "\n")

      # Check hit. If miss, pass to the opponent, else check game over condition
      if res == 'miss'
        p1[0].miss
        @players.reverse!
        last_shots = []
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
