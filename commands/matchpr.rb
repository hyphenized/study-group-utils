#
# BASIC COMMAND TEMPLATE
#
#
class MatchPeerReviews < Command
  NORMAL = 0
  FILL_MODE = 1

  def initialize
    @_name = "matchpr"
    @mode = NORMAL
    super
  end

  def run(**kwargs)
    # We get a hash map with the name of the assignment as a key, and the values are all the PRs
    past_assignments = kwargs[:cli].past_assignments
    @students = kwargs[:cli].students

    # Ask which assignment past_assignments.keys does the user want to match
    #
    #  TODO: Ask the assignment
    #

    @prs = past_assignments["Structuring HTML Pages"]

    # TODO: Read the max reviews per assigment in config file and add in main
    @max_reviews_per_assignment = 2

    if (past_assignments["Structuring HTML Pages"].size - @students.size).negative?
      puts "The minimum number of assignments required is #{@students.size}. We are running in fill mode."
      @mode = FILL_MODE
      @max_reviews_per_assignment += 1
    end

    # We give the selected assignment to do the matches
    match

=begin
    #Check the occurrences
    ids = []
    @prs.compact!
    @prs.each do |match|
      match["reviewers"].each { |id| ids << id }
    end

    p ids.tally
=end

    matched_array_columns = match_to_csv
    matched_array_columns.each { |row| puts row.join(", ") }

    puts "Do you want to save this match? (Y/N)"
    yes_or_no = gets.chomp.upcase
    case yes_or_no
    when "Y"
      print "File name: "
      file_name = gets.chomp
      csv = CSV.generate("", encoding: "UTF-8") do |csv|
        matched_array_columns.each { |row| csv << row }
      end
      File.open("#{file_name}.csv", "w") { |file| file.write(csv) }
    when "N"
      puts "Match discarded."
    else
      puts "Invalid, try again."
    end
  end

  # assignment_prs is an array of PRs
  # a PR has this form { "id" => "38",  "assignmentName" => "Structuring HTML pages", "url" => "https://github.com/codeableorg/html-essentials/pull/1", "submittedBy" => [ {"id" => "30"}]}
  def match
    # We transform the submittedBy to an array of integers and add a new key "reviewers" where we are going to store the reviews of this PR
    @prs.each do |pr_obj|
      pr_obj["submittedBy"] = pr_obj["submittedBy"].inject([]) { |memo, el| memo << el["id"].to_i; memo }
      pr_obj["reviewers"] = Array.new(@max_reviews_per_assignment)
    end

    # For each PR we are going to fill in the students
    @students_id_map = students_by_id(@students)
    @students_available_with_count = @students_id_map.to_h { |id, _name| [id, 0] }
    case @mode
    when FILL_MODE
      @students_id_map.keys.each { |student_id|
        add_id_in_free_space(@prs[pick_random_pr(student_id)], student_id)
      }
    when NORMAL
      @prs.each { |pr_obj|
        until has_full_reviewers(pr_obj)
          random_student_id = pick_random_student(pr_obj)
          add_id_in_free_space(pr_obj, random_student_id)
          add_student_review_count(random_student_id)
        end
      }
    end
  end

  def pick_random_student(pr_obj)
    loop do
      random_student_id = @students_available_with_count.keys.sample
      return random_student_id if @students_available_with_count.size <= @max_reviews_per_assignment
      next if pr_obj["submittedBy"].include?(random_student_id) || pr_obj["reviewers"].include?(random_student_id)
      return random_student_id
    end
  end

  def pick_random_pr(student_id)
    loop do
      random_pr_pos = rand(@prs.size)
      next if @prs[random_pr_pos]["submittedBy"].include?(student_id)
      return random_pr_pos
    end
  end

  def students_by_id(students)
    students.to_h { |key, id| [key, id.to_i] }.invert
  end

  def add_student_review_count(id)
    @students_available_with_count[id] += 1
    # If you are maxed out, you are not available anymore
    @students_available_with_count.delete(id) if @students_available_with_count[id] >= @max_reviews_per_assignment
  end

  def has_full_reviewers(pr_hash)
    pr_hash["reviewers"].compact.size == @max_reviews_per_assignment
  end

  def add_id_in_free_space(pr_hash, id)
    pr_hash["reviewers"].each_with_index { |reviewer_id, index|
      if reviewer_id.nil?
        pr_hash["reviewers"][index] = id
        return
      end
    }
  end

  def match_to_csv
    @students_id_map.map do |k, v|
      row = [v]
      @prs.select { |pr| pr["reviewers"].include?(k) }.each { |match| row << match["url"] }
      row
    end
  end
end

$_commands[__FILE__] = MatchPeerReviews.new
