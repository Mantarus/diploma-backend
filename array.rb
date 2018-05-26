class Array
  def add b
    self.zip(b).map {|l| l.reduce(:+)}
  end
end