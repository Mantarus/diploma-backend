# class Ship
class Ship
  attr_reader :coord, :len

  def initialize(field, len)
    @len = len
    @my_field = field
    @max_health = 100 * len
    @min_health = 30 * len
    @health = @max_health
  end

  def to_s
    'X'
  end

  # Removes the ship from the field
  def clear
    @my_field.set!(@len, @coord[0], @coord[1], @hor)
  end

  # Places the ship at [x, y] coords
  def set!(x, y, horizontal)
    # Check that the ship can be placed at the given coords
    if @my_field.free_space?(@len, x, y, horizontal, self)
      # If success, remove the ship from the old position and place at the new one
      clear if @coord
      @my_field.set!(@len, x, y, horizontal, self)
      # Renew coords
      dim = [0, @len - 1]
      dim.reverse! if horizontal
      @coord = [x, y] + ([x, y].add dim)
      @hor = horizontal
      true
    else
      false
    end
  end

  # Kills the ship
  def kill
    clear
    @coord = nil
  end

  # Handles the shot
  def explode
    @health -= 70
    if @health <= @min_health
      kill
      return @len
    end
    nil
  end

  # Heals the ship
  def cure
    @health += 30
    @health = @max_health if @health > @max_health
  end

  # Returns ship's health in percents
  def health
    (100 * @health.to_f / @max_health).round(2)
  end

  # Makes a linear move
  def move(forward)
    moves = [0, forward ? 1 : -1]
    moves.reverse! if @hor
    new_coord = @coord.add(moves + moves)
    set!(new_coord[0], new_coord[1], @hor)
  end

  # Makes a rotation
  def rotate(center, rotation_type)
    if center.between?(1, @len)
      new_hor = rotation_type.odd? ? !@hor : @hor
      if rotation_type == 1
        if @hor
          new_coord = [@coord[0] + center - 1, @coord[1] - center + 1]
        else
          new_coord = [@coord[2] + center - @len, @coord[3] + center - @len]
        end
        set!(new_coord[0], new_coord[1], new_hor)

      elsif rotation_type == 2
        if @hor
          new_coord = [@coord[2] + 2 * center - 2 * @len, @coord[3]]
        else
          new_coord = [@coord[2], @coord[3] + 2 * center - 2 * @len]
        end
        set!(new_coord[0], new_coord[1], new_hor)

      elsif rotation_type == 3
        if @hor
          new_coord = [@coord[2] + center - @len, @coord[3] + center - @len]
        else
          new_coord = [@coord[0] - center + 1, @coord[1] + center - 1]
        end
        set!(new_coord[0], new_coord[1], new_hor)

      else
        false
      end

    else
      false
    end
  end
end