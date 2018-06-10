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
    @log = ''
  end

  def start
    game_result = GameResult.new(nil, nil)
    last_shots = []
    log_p = true

    until @game_over

      # Init players
      p1 = @players[0]
      p2 = @players[1]

      # Залогировать изначальное расположение кораблей
      if log_p
        log_placement(p1).each do |record|
          log(record)
        end
        # p1[1].print_field

        log_placement(p2).each do |record|
          log(record)
        end
        # p2[1].print_field

        log_p = false
      end

      # Увеличить счетчик ходов
      p1[2] += 1

      # Лечение кораблей
      p1[1].cure

      # Залогировать здоровье кораблей
      log_hp(p1).each do |record|
        log(record)
      end

      # Игрок перемещает либо вращает один из своих кораблей
      # и затем делает выстрел
      move = p1[0].ship_move_strategy(p1[1].remains)
      move_res = p1[1].move(move)

      shot = p1[0].shot_strategy

      # Проверка на illegal shot
      if last_shots.include? shot
        res = 'miss'
      else
        last_shots.push shot
        res = p2[1].shoot shot
      end

      if move_res
        log(log_move(p1, move))
        log(log_shot(p1[0].name, shot, res, p2))
      end

      # Check hit. If miss, pass to the opponent, else check game over condition
      if res == 'miss'
        p1[0].miss
        @players.reverse!
        last_shots = []
      else
        p1[0].hit res
        @game_over = p2[1].game_over?
        if @game_over
          game_result.winner = p1[0].name
          game_result.game_log = @log
          break
        end
      end
    end

    game_result
  end

  def read_game_log
    @log
  end

  private

  def reset(player_arr)
    # print(player_arr[0].name, " game setup\n")
    player_arr[0].reset
    player_ships = player_arr[1].fleet
    if !player_arr[1].place_fleet(player_arr[0].place_strategy(player_ships))
      raise 'Illegal ship placement'
    else
      # puts 'Ships placed'
    end
  end

  def log(string)
    @log += string + "\n"
  end

  def log_shot(player, shot, res, opponent)
    if res == 'wounded'
      ship_coords = opponent[1].get_cell(shot[0], shot[1]).coord
      ship = opponent[1].remains.select do |ship|
        ship[1] == ship_coords
      end[0]
      "#{player}\ts\t#{shot[0]}\t#{shot[1]}\t#{res}\t#{ship[0]}\t#{ship[3]}"
    else
      "#{player}\ts\t#{shot[0]}\t#{shot[1]}\t#{res}"
    end
  end

  # Return p num len hor x y
  def log_placement(player)
    arr = []

    player[1].remains.each do |ship|
      coords = calc_coords(ship[1])
      arr.append("#{player[0].name}\t#{ship[0]}\t#{ship[2]}\t#{coords[2]}\t#{coords[0]}\t#{coords[1]}")
    end

    arr
  end

  # Return p num hp
  def log_hp(player)
    arr = []

    player[1].remains.each do |ship|
      arr.append("#{player[0].name}\t#{ship[0]}\t#{ship[3]}")
    end

    arr
  end

  def log_move(player, move)
    ship_idx = move[0]
    ship = player[1].remains.select do |elem|
      elem[0] == ship_idx
    end[0]
    coords = calc_coords(ship[1])
    "#{player[0].name}\t#{ship_idx}\t#{coords[2]}\t#{coords[0]}\t#{coords[1]}"
  end

  def calc_coords(coords)
    x = coords[0]
    y = coords[1]
    hor = coords[0] == coords[2]
    [x, y, hor]
  end

end

# class GameResult
class GameResult
  attr_accessor :winner, :game_log

  def initialize(winner, game_log)
    @winner = winner
    @game_log = game_log
  end
end