# class Array
class Array
  def add(element)
    zip(element).map { |l| l.reduce(:+) }
  end
end