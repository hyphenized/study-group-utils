#
# EXAMPLE COMMAND TEMPLATE
#
#
class Print < Command
  NAME = "print"
  DESCRIPTION = "Outputs something to the CLI"
  def initialize
    super
  end

  def run(**kwargs)
    puts kwargs[:args]
  end
end

$_commands[__FILE__] = Print.new
