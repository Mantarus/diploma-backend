require './array.rb'
require './battlefield.rb'
require './field.rb'
require './game.rb'
require './ship.rb'
require './response.rb'

require 'FileUtils'

class GameController

  def initialize(strategy1, strategy2)

    srand
    @strategy1 = strategy1
    @strategy2 = strategy2
  end

  def play_game

    module1 = generate_module_name
    module2 = generate_module_name

    @strategy1 = add_module_definition(@strategy1, module1)
    @strategy2 = add_module_definition(@strategy2, module2)

    file1 = generate_file_name
    file2 = generate_file_name

    open(file1, 'w') { |f| f.puts @strategy1 }
    open(file2, 'w') { |f| f.puts @strategy2 }

    begin
    load file1
    rescue SyntaxError => error
      message = handle_syntax_error(error, file1)
      FileUtils.remove file2
      return Response.new(false, nil, nil, message)
    end

    begin
      load file2
    rescue SyntaxError => error
      message = handle_syntax_error(error, file2)
      FileUtils.remove file1
      return Response.new(false, nil, nil, message)
    end

    FileUtils.remove file1
    FileUtils.remove file2

    begin
      p1 = eval "#{module1}::Player.new('P1')"
      p2 = eval "#{module2}::Player.new('P2')"
      g = Game.new(p1, p2)
      result = g.start

      Object.send(:remove_const, module1)
      Object.send(:remove_const, module2)

      Response.new(true, result.winner, result.game_log, nil)
    rescue => error
      Object.send(:remove_const, module1)
      Object.send(:remove_const, module2)
      return Response.new(false, nil, nil, error.message)
    end

  end

  private

  def generate_file_name
    "strategy_#{srand}.rb"
  end

  def generate_module_name
    "Module_#{srand}"
  end

  def add_module_definition(class_definition, module_name)
    "module #{module_name}\n#{class_definition}\nend"
  end

  def handle_syntax_error(syntax_error, file)
    FileUtils.remove file
    syntax_error.message
  end

end