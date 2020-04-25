#
# BASIC COMMAND TEMPLATE
#
#
class MatchPeerReviews < Command
  def initialize
    @_name = "MatchPeerReviews"
    super
  end

  def run(**kwargs)
    puts kwargs[:cli].config
  end
end

$_commands[__FILE__] = MatchPeerReviews.new
