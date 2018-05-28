require './array.rb'

# class Field
class Field
  def initialize
    @field = Array.new(FIELD_SIZE) { Array.new(FIELD_SIZE) }
  end

  FIELD_SIZE = 10

  # Returns field size
  def self.size
    FIELD_SIZE
  end

  # Sets a ship on the field
  def set!(ship_len, x, y, horizontal, ship = nil)
    dims = [1, ship_len]
    dims.reverse! if horizontal
    @field[x, dims[0]].each do |row|
      row[y, dims[1]] = Array.new(dims[1], ship)
    end
  end

  # Prints field state on the screen
  def print_field
    # Print top border
    print '+'
    (1..Field.size).each { print '-' }
    print "+\n"

    # Print each field row
    @field.each do |row|
      print '|'
      row.each { |x| print(!x ? ' ' : x.to_s) }
      print "|\n"
    end

    # Print bottom border
    print '+'
    (1..Field.size).each { print '-' }
    print "+\n"
    nil
  end

  # Returns true if ship with the given parameters can be placed on the field
  def free_space?(ship_len, x, y, horizontal, ship = nil)
    field_begin = [x, y]
    dims = [0, ship_len - 1]
    dims.reverse! if horizontal
    field_end = field_begin.add dims

    # Check that ship is between field borders
    if (field_begin + field_end).all? { |a| a.between?(0, FIELD_SIZE - 1) }
      dims = dims.add [1, 1]
      field_begin.each_index do |i|
        if field_begin[i] > 0
          field_begin[i] -= 1
          dims[i] += 1
        end
      end

      field_end.each_index do |i|
        dims[i] += 1 if field_end[i] < FIELD_SIZE - 1
      end

      @field[field_begin[0], dims[0]].all? do |row|
        row[field_begin[1], dims[1]].all? { |cell| !cell || cell == ship }
      end
    else
      false
    end
  end
end