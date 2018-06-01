class Player
  attr_reader :name
  attr_accessor :manual
  def initialize (name, manual = false)
    @name = name
    @manual = manual
    @lastsample = [1, 0]
    reset
  end

  def reset
    @lastshots = []
    @allshots = []
  end

  # Задание 27 random_point
  def random_point
    coords = (0..Field.size-1).to_a
    [coords.sample, coords.sample]
  end

  # Задание 28 place_strategy ship_list
  def place_strategy ship_list
    tmp_field = Field.new
    dirs = [true, false]
    res = []
    (ship_list.sort {|x,y| y[1] <=> x[1]}).each do |s|
      flag = false
      while !flag
        p = random_point
        hor = dirs.sample
        if tmp_field.free_space?(s[1], p[0], p[1], hor, s[0])
          tmp_field.set!(s[1], p[0], p[1], hor, s[0])
          res.push [s[0], p[0], p[1], hor]
          flag = true
        end
      end
    end
    res
  end

  # Задание 29 hit message
  #            miss
  def hit message
    @lastshots.push [@shot, message]
  end

  def miss
    @lastshots.push [@shot, "miss"]
    @allshots.push @lastshots
    @lastshots = []
  end

  # Задание 30 shot_strategy
  def shot_strategy
    if @manual
      while true
        shot = [x,y]
        if shot.all? {|a| a.between?(-1, Field.size - 1)}
          break
        end
      end
      if shot.any? {|a| a == -1}
        @manual = false
        shot_strategy
      else
        @shot = shot
      end
    else
      if @lastshots.length == 0 || @lastshots[-1][1][0,6] == "killed"
        @shot = random_point
      else
        if @lastshots.length == 1 || @lastshots[-2][1][0,6] == "killed"
          @lastsample = [[0,1],[0,-1],[1,0],[-1,0]].sample
        end
        @shot = @shot.add @lastsample
        if ! @shot.all? {|x| x.between?(0, Field.size-1)}
          @lastsample = @lastsample.map {|x| -x}
          @shot = (@lastshots[-1][0]).add @lastsample
        end
      end
      if @lastshots.any? {|x| x[0] == @shot}
        shot_strategy
      else
        @shot
      end
    end
  end

  def ship_move_strategy remains
    if @manual
      tmp_field = Field.new
      names = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a
      ship_hash = {}
      remains.each do |ship|
        name = names[ship[0]]
        x = ship[1][0]; y = ship[1][1]
        hor = (ship[1][1] == ship[1][3])
        ship_hash[name] = [ship[0], ship[2]]
        tmp_field.set!(ship[2], x, y, hor, name)
      end

      while true
        name = gets.strip;
        if !ship_hash[name] then break end
        move = 0
        begin
          move = gets.to_i;
        end until move.between?(0,3)
        if move == 0

        else
          dir = 0
          begin
            dir = gets.to_i;
          end until dir.between?(1,ship_hash[name][1])
        end
        break
      end
      if !ship_hash[name]
        @manual = false
        ship_move_strategy remains
      else
        [ship_hash[name][0], move, dir]
      end
    else
      weakest = (remains.sort {|a, b| a[3] <=> b[3]})[0]
      move = (0..3).to_a.sample
      point = (1..weakest[2]).to_a.sample
      [weakest[0], move, point]
    end
  end
end