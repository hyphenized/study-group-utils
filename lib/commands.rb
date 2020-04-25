# A CLI command
class Command
  attr_reader :_description, :_usage
  def initialize
    @_name ||= "Unnamed command"
    @_description ||= "There's no information about this command"
    @_usage ||= @_description
    puts "Loaded command - #{@_name}"
  end

  def get_help
    [@_description, @_usage]
  end

  # Runs the command
  def run(**kwargs)
    puts "This command does nothing"
  end
end

# Utility commands for the CLI
module BasicCommands
  class Help < Command
    def initialize
      @_name = "help"
      @_description = "Outputs help about a command"
      @_usage = "help <command_name>"
      super
    end

    def run(**kwargs)
      # user asked for help about a command
      unless (args = kwargs[:args]).empty?
        cmd = args.split.shift
        unless $_commands[cmd].nil?
          description, usage = $_commands[cmd].get_help
          puts description
          puts usage if usage != description
          return
        end
      end

      students = kwargs[:cli].students.keys.map { |x| x.center(30) }
      students = Array.new(students.size) do |i|
        students[i] << (i.odd? ? "\n" : "")
      end.join
      puts sprintf(Messages::HELP, students)
    end
  end

  class Exit < Command
    def initialize
      @_name = "exit"
      @_description = "Exits the program"
      super
    end

    def run(**kwargs)
      puts "Exiting...."
      exit(0)
    end
  end
end
