#
# BASIC COMMAND TEMPLATE
#
#
class StudyGroups < Command
  def initialize
    @_name = "mkgroups"
    @_description = "Creates study groups"
    super
  end

  def run(**kwargs)
    # @type [CLI]
    cli = kwargs[:cli]
    matrix = StudentMatrix.new(cli.students, cli.config["group_size"])
    matrix.generate_groups!
    display_groups(matrix.get_groups)

    if get_confirmation("Would you like to save these results?")
      filename = prompt("Filename?", required: false)
      # file_fmt = prompt("Format? Enter to use default (csv):")
      f_exists = File.exists?(filename)
      if (f_exists && get_confirmation("File exists, overwrite?")) || !f_exists
        File.open(filename, "w") do |file|
          file.write(matrix.get_groups)
        end
        puts "File saved.."
      end
    else
      puts "Ok then.."
    end
  end

  # @param groups [Array<Array<Integer>>]
  def display_groups(groups)
    puts "The following groups have been generated:\n"
    groups.each_with_index do |group, index|
      puts "#{index + 1}: #{group.join(', ')}"
    end
    puts "-" * 60
  end
end

$_commands[__FILE__] = StudyGroups.new
