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
    matrix.load_ocurrences(cli.past_groups)
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
      # We save a copy as a past group
      folder_name = cli.config["past_files_folder"]
      name = cli.config["past_files_prefix"]
      count = Dir["#{folder_name}/#{name}*.csv"].size
      File.open("#{folder_name}/#{name}#{count + 1}.csv", "w") do |file|
        file.write(matrix.to_csv)
      end
    else
      puts "Ok then.."
    end
  end

  # @param groups [Array<Array<Integer>>]
  def display_groups(groups)
    puts "The following groups have been generated:\n"
    groups.each_with_index do |group, index|
      puts "#{index + 1}: #{group.join(", ")}"
    end
    puts "-" * 60
  end
end

$_commands[__FILE__] = StudyGroups.new
