# A CLI command
class Command
  NAME = "Unnamed command"
  DESCRIPTION = "There's no information about this command"
  USAGE = DESCRIPTION
  def initialize
    puts "Loaded command - #{self.class::NAME}"
  end

  # Returns description and usage about a command
  # @return [Array<String>]
  def get_help
    [self.class::DESCRIPTION, self.class::USAGE]
  end

  # Gets confirmation from the user
  # @param msg [String]
  # @return [Boolean]
  def get_confirmation(msg)
    print msg << "(y/n) "
    loop do
      answer = gets
      if answer.nil?
        return false
      end
      case answer.strip
      when "y", "yes" then break true
      when "n", "no" then break false
      else
        puts "Invalid answer, must be y/n or yes/no"
      end
    end
  end

  # @param msg [String]
  # @param required [Boolean=false]
  def prompt(msg, required: false)
    print "#{msg} "
    loop do
      answer = gets
      if answer.nil?
        return "" unless required
        puts "\nAnswer was required, aborting..."
        exit(1)
      end
      break answer.strip unless required && answer.empty?
      puts "Cannot be empty"
    end
  end

  # Runs the command
  def run(**kwargs)
    puts "This command doesn't do anything yet"
  end
end

# Utility commands for the CLI
module BasicCommands
  class Help < Command
    NAME = "help"
    DESCRIPTION = "Outputs help about a command"
    USAGE = "help <command_name>"
    def initialize
      super
    end

    def run(**kwargs)
      # user asked for help about a command
      unless (args = kwargs[:args]).empty?
        cmd = args.split.shift
        unless $_commands[cmd].nil?
          description, usage = $_commands[cmd].get_help
          puts description
          puts usage if usage != Command::DESCRIPTION
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
    NAME = "exit"
    DESCRIPTION = "Exits the program"
    def initialize
      super
    end

    def run(**kwargs)
      puts "Exiting...."
      exit(0)
    end
  end
end
