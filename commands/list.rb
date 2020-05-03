#
# BASIC COMMAND TEMPLATE
#
#
class List < Command
  NAME = "list"
  def initialize
    super
  end

  # @param args [Array<String>] Arguments passed
  # @param cli [StudyGroupUtils] The CLI instance that ran this script
  def run(cli:, args:, **kwargs)
    puts `ls -l`
  end
end

StudyGroupUtils[__FILE__] = List.new
