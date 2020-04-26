#
# BASIC COMMAND TEMPLATE
#
#
class Clear < Command
  def initialize
    @_name = "clear"
    @_description = "Clears the console"
    super
  end

  def run(**kwargs)
    system('clear') || system('cls')
  end
end

$_commands[__FILE__] = Clear.new
