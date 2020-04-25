#
# BASIC COMMAND TEMPLATE
#
#
class MatchPeerReviews < Command
  def initialize
    @_name = "matchpr"
    super
  end

  def run(**kwargs)
    puts kwargs[:cli].past_assignments
  end
end

$_commands[__FILE__] = MatchPeerReviews.new
