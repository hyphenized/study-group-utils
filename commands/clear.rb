#
# BASIC COMMAND TEMPLATE
#
#
class Clear < Command
  NAME = "clear"
  DESCRIPTION = "Clears the console"
  def initialize
    super
  end

  def run(**kwargs)
    system('clear') || system('cls')
  end
end

$_commands[__FILE__] = Clear.new
