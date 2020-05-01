#
# BASIC COMMAND TEMPLATE
#
#
class StudyGroups < Command
  NAME = "mkgroups"
  DESCRIPTION = "Creates study groups"
  def initialize
    super
  end

  def run(**kwargs)
    # @type [CLI]
    cli = kwargs[:cli]
    matrix = StudentMatrix.new(cli.students, cli.config["group_size"])
    past_groups = load_past_groups(folder: cli.config["past_files_folder"])

    matrix.load_ocurrences(past_groups)
    matrix.generate_groups!
    display_groups(matrix.get_groups)
    matrix.social_students.each { |student| puts "#{student} has already worked with everyone" }

    if get_confirmation("Would you like to save these results?")
      puts "Filename? Add extension to use custom format"
      filename = prompt("(default: output.csv):")
      filename = filename.empty? ? "output.csv" : filename
      f_exists = File.exists?(filename)
      ext_name = File.extname(filename)
      if (f_exists && get_confirmation("File exists, overwrite?")) || !f_exists
        filename = ext_name.empty? ? "#{filename}.csv" : filename
        File.open(filename, "w") do |file|
          case ext_name
          when ".json"
            file.write(matrix.to_json)
          when ".csv", ""
            file.write(matrix.to_csv)
          when ".yml"
            file.write(matrix.to_yml)
          else
            file.write(matrix.get_groups)
          end
        end
        puts "File saved.."
      end
    else
      puts "Ok then.."
    end
  end

  # Prints generated groups to the console
  # @param groups [Array<Array<Integer>>]
  def display_groups(groups)
    puts "The following groups have been generated:\n"
    groups.each_with_index do |group, index|
      puts "#{index + 1}: #{group.join(', ')}"
    end
    puts "-" * 60
  end

  # Returns past_groups
  # @param folder [String] Where to look for past groups
  def load_past_groups(folder:)
    return [] unless File.directory?(folder)

    Dir["#{folder}/*.csv"].map do |filename|
      ReadFile.new(filename).read.group_by { |row| row["study_group"] }
    end
  end
end

$_commands[__FILE__] = StudyGroups.new
