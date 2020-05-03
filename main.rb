require './lib/study_group_utils.rb'

# check if app was started with parameters
if ARGV.length > 1
  StudyGroupUtils.new.run_only(ARGV)
else
  StudyGroupUtils.new.start
end
