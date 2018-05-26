require './field.rb'

class BattleField < Field
  def initialize
    super
    newships
  end

  SHIPS = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1].freeze

  def newships
    @allships = SHIPS.map { |len| Ship.new(self, len)}
  end

  # Задание 18 fleet
  def fleet
    @allships.each_with_index.map {|x, i| [i, x.len]}
  end

  # Задание 19 place_fleet pos_list
  def place_fleet pos_list
    res = pos_list.inject(true) do |a, l|
      a && @allships[l[0]].set!(l[1], l[2], l[3])
    end
    if res
      res = @allships.inject(true) {|a, ship| a && ship.coord}
    end
    if !res
      @allships.each {|ship| if ship.coord then ship.kill end}
    end
    res
  end

  # Задание 20 remains
  def remains
    @allships.each_with_index.map {|x, i| [i, x.coord, x.len, x.health]}
  end

  # Задание 21 refresh
  def refresh
    @allships = @field.reduce(:|).find_all {|x| x}
  end

  # Задание 22 shoot c
  def shoot c
    x = c[0]; y = c[1]
    if @field[x][y]
      if res = @field[x][y].explode
        refresh
        "killed #{res}"
      else
        "wounded"
      end
    else
      "miss"
    end
  end

  # Задание 23 cure
  def cure
    @allships.each {|ship| ship.cure}
  end

  # Задание 24 game_over?
  def game_over?
    @allships.empty?
  end

  # Задание 25 move l_move
  def move l_move
    is_rot = l_move[1].between?(1,3)
    direction = l_move[2] == 1
    if is_rot
      @allships[l_move[0]].rotate(l_move[2], l_move[1])
    else
      @allships[l_move[0]].move direction
    end
  end
end