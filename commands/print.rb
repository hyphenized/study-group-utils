#
# EXAMPLE COMMAND TEMPLATE
#
#
class Print < Command
  def initialize
    @_name = "Print CMD"
    @_description = "Print CMD"
    super
  end
end

$_commands[__FILE__] = Print.new
