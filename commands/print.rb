#
# EXAMPLE COMMAND TEMPLATE
#
#
class Print < Command
  def initialize
    @_name = "print"
    @_description = "Outputs something to the CLI"
    super
  end

  def run(**kwargs)
    puts kwargs[:args]
  end
end

$_commands[__FILE__] = Print.new
