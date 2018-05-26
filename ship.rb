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

  def clear
    @my_field.set!(@len, @coord[0], @coord[1], @hor)
  end

  def set!(x, y, hor)
    if @my_field.free_space?(@len, x, y, hor, self)
      if @coord then clear end
      @my_field.set!(@len, x, y, hor, self)
      dim = [0, @len - 1]
      if hor then dim.reverse! end
      @coord = [x, y] + ([x, y].add dim)
      @hor = hor
      true
    else
      false
    end
  end

  def kill
    clear
    @coord = nil
  end

  def explode
    @health -= 70
    if @health <= @min_health
      kill
      return @len
    end
    nil
  end

  def cure
    @health += 30
    if @health > @max_health then @health = @max_health end
  end

  def health
    (100 * @health.to_f / @max_health).round(2)
  end

  def move(forward)
    moves = [0, forward ? 1 : -1]
    if @hor then moves.reverse! end
    new_coord = @coord.add(moves + moves)
    set!(new_coord[0], new_coord[1], @hor)
  end

  def rotate(n, k)
    if n.between?(1, @len)
      new_hor = k.odd? ? !@hor : @hor
      if k == 1
        if @hor
          new_coord = [@coord[0] + n - 1, @coord[1] - n + 1]
        else
          new_coord = [@coord[2] + n - @len, @coord[3] + n - @len]
        end
        set!(new_coord[0], new_coord[1], new_hor)

      elsif k == 2
        if @hor
          new_coord = [@coord[2] + 2 * n - 2* @len, @coord[3]]
        else
          new_coord = [@coord[2], @coord[3] + 2 * n - 2* @len]
        end
        set!(new_coord[0], new_coord[1], new_hor)

      elsif k == 3
        if @hor
          new_coord = [@coord[2] + n - @len, @coord[3] + n - @len]
        else
          new_coord = [@coord[0] - n + 1, @coord[1] + n - 1]
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