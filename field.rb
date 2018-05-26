require './array.rb'

class Field
  def initialize
    @field = Array.new(FieldSize) {Array.new(FieldSize)}
  end

  FieldSize = 10

  def self.size
    FieldSize
  end

  def set!(n, x, y, hor, ship=nil)
    dims = [1, n]
    if hor then dims.reverse! end
    @field[x, dims[0]].each do |row|
      row[y, dims[1]] = Array.new(dims[1], ship)
    end
  end

  def print_field
    print "+"
    (1..Field.size).each {print "-"}
    print "+\n"
    @field.each do |row|
      print "|"
      row.each {|x| print (!x ? " " : x.to_s)}
      print "|\n"
    end
    print "+"
    (1..Field.size).each {print "-"}
    print "+\n"
    nil
  end

  def free_space? (n, x, y, hor, ship = nil)
    field_b = [x,y]
    dims = [0,n-1]
    if hor then dims.reverse! end
    field_e = field_b.add dims
    if (field_b + field_e).all? {|a| a.between?(0, FieldSize - 1)}
      dims = dims.add [1, 1]
      field_b.each_index do |i|
        if field_b[i] > 0
          field_b[i] -= 1
          dims[i] += 1
        end
      end
      field_e.each_index do |i|
        if field_e[i] < FieldSize - 1 then dims[i] += 1 end
      end
      @field[field_b[0], dims[0]].all? do |row|
        row[field_b[1], dims[1]].all? {|cell| !cell || cell == ship}
      end
    else
      false
    end
  end

end