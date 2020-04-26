#
# BASIC COMMAND TEMPLATE
#
#
class List < Command
  def initialize
    @_name = "list"
    super
  end

  def run
    p `ls -l`
  end
end

$_commands[__FILE__] = List.new
