# A CLI command
class Command
  attr_reader :_description
  def initialize
    @_name ||= "Unnamed command"
    @_description ||= "There's no information about this command"
    puts "Loading command - #{@_name}"
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
    end
    
    def run(**kwargs)
      students = kwargs[:cli].students.keys.map{|x| x.center(30)}
      students = Array.new(students.size) do |i|
         x = students[i] << (i.odd? ? "\n" : "")
      end.join("")
      puts sprintf(Messages::HELP, students)
    end
  end

  class Exit < Command
    def initialize
      @_name = "exit"
      @_description = "exits the program"
    end

    def run(**kwargs)
      puts "Exiting...."
      exit(0)
    end
  end
end
