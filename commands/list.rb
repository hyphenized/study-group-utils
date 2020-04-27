#
# BASIC COMMAND TEMPLATE
#
#
class List < Command
  NAME = "list"
  def initialize
    super
  end

  def run
    p `ls -l`
  end
end

$_commands[__FILE__] = List.new
