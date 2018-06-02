require './array.rb'
require './battlefield.rb'
require './field.rb'
require './game.rb'
require './ship.rb'
require './response.rb'

require 'FileUtils'

class GameController
  @@count = 0

  def initialize(strategy1, strategy2)
    @@count += 1
    @id = @@count

    srand
    @strategy1 = strategy1
    @strategy2 = strategy2
  end

  def play_game
    puts "Playing controller #{@id}"

    module1 = add_module_definition(@strategy1, 'ModuleA')
    module2 = add_module_definition(@strategy2, 'ModuleB')

    file_a = generate_file_name
    file_b = generate_file_name

    open(file_a, 'w') { |f| f.puts module1 }
    open(file_b, 'w') { |f| f.puts module2 }

    begin
    load file_a
    rescue SyntaxError => error
      message = handle_syntax_error(error, file_a)
      FileUtils.remove file_b
      return Response.new(false, nil, nil, message)
    end

    begin
      load file_b
    rescue SyntaxError => error
      message = handle_syntax_error(error, file_b)
      FileUtils.remove file_a
      return Response.new(false, nil, nil, message)
    end

    FileUtils.remove file_a
    FileUtils.remove file_b

    begin
      p1 = ModuleA::Player.new('P1')
      p2 = ModuleB::Player.new('P2')
      g = Game.new(p1, p2)
      result = g.start

      Object.send(:remove_const, :ModuleA)
      Object.send(:remove_const, :ModuleB)

      Response.new(true, result.winner, result.game_log, nil)
    rescue => error
      Object.send(:remove_const, :ModuleA)
      Object.send(:remove_const, :ModuleB)
      return Response.new(false, nil, nil, error.message)
    end

  end

  private

  def generate_file_name
    "strategy_#{srand}.rb"
  end

  def add_module_definition(class_definition, module_name)
    "module #{module_name}\n#{class_definition}\nend"
  end

  def handle_syntax_error(syntax_error, file)
    FileUtils.remove file
    syntax_error.message
  end

end