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

  # @param args [Array<String>] Arguments passed
  # @param cli [StudyGroupUtils] The CLI instance that ran this script
  def run(cli:, args:, **kwargs)
    system('clear') || system('cls')
  end
end

StudyGroupUtils[__FILE__] = Clear.new
