require './field.rb'

# class Battlefield
class BattleField < Field
  def initialize
    super
    new_ships
  end

  SHIPS = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1].freeze

  def get_cell(x, y)
    @field[x][y]
  end

  # Initializes ships array
  def new_ships
    @all_ships = SHIPS.map { |len| Ship.new(self, len) }
  end

  # Returns information about all ships on the battlefield
  def fleet
    @all_ships.each_with_index.map { |x, i| [i, x.len] }
  end

  # Places ships on the field by given position array
  def place_fleet(pos_list)
    # Try to set all ships on the field
    res = pos_list.inject(true) do |a, l|
      a && @all_ships[l[0]].set!(l[1], l[2], l[3])
    end

    # If success, check something???
    res = @all_ships.inject(true) { |a, ship| a && ship.coord } if res

    # Remove all ships otherwise
    @all_ships.each { |ship| ship.kill if ship.coord } if !res

    res
  end

  # Returns current state of the fleet
  def remains
    @all_ships.each_with_index.map { |x, i| [i, x.coord, x.len, x.health] }
  end

  # Refresh ships list, removing killed ships
  def refresh
    @all_ships = @field.reduce(:|).find_all { |x| x }
  end

  # Lands a shot at current battlefield
  def shoot(coords)
    x = coords[0]
    y = coords[1]

    # Check that there is a ship at [x, y]
    if @field[x][y]
      # Check that ship is killed
      if (res = @field[x][y].explode)
        refresh
        "killed #{res}"
      else
        'wounded'
      end
    else
      'miss'
    end
  end

  # Heals all wounded ships
  def cure
    @all_ships.each(&:cure)
  end

  # Checks that there is no more ships on the battlefield
  def game_over?
    @all_ships.empty?
  end

  # Makes a move
  # @param [Array] move_params - [i, move_t, dir]
  # i - number of the ship
  # move_t - type of the move (move, rotate)
  # dir - move param
  def move(move_params)
    # Check for rotation
    is_rot = move_params[1].between?(1, 3)
    # Set direction
    direction = move_params[2] == 1
    if is_rot
      @all_ships[move_params[0]].rotate(move_params[2], move_params[1])
    else
      @all_ships[move_params[0]].move direction
    end
  end
end