require 'json'
require 'yaml'
require 'csv'
require 'readline'
require_relative 'lib/lib.rb'

Encoding.default_external = "UTF-8"

class BaseCLI
  # @type [Hash{String => Command}]
  @@commands = Hash.new(nil)

  # Returns a command or nil if it doesn't exist
  # @param cmd_name [String]
  # @return [Command, nil]
  def self.[](cmd_name)
    @@commands[cmd_name]
  end

  # Adds a command
  # @param cmd_name [String]
  # @return [Command]
  def self.[]=(fname, command)
    cmd_name = File.basename(fname).sub(File.extname(fname), '')
    @@commands[cmd_name] = command
  end

  # Loads basic commands and warns the user if the command name is reserved
  def self.add_base_cmd(name, instance)
    if !@@commands[name].nil?
      puts "Command #{name} is reserved, it won't work unless you rename the file"
      print "Press Enter to continue "
      gets
    end
    @@commands[name] = instance.new
  end
end

# Starts as CLI or Runs a command and exits
class StudyGroupUtils < BaseCLI
  attr_reader :students, :config

  def initialize
    @config = CLIConfig.load
    @students = load_students(students_json: @config["student_list"])
    # Load commands
    Dir["commands/*.rb"].each { |file| load(file, true) }
    # Load basic commands
    BasicCommands.all.each { |cmd| self.class.add_base_cmd(*cmd) }
  end

  # Starts cli mode
  def start
    puts "Entering CLI mode..."
    commands["help"].run(args: "", cli: self)
    while input = Readline.readline("> ", true)
      command, *args = input.split
      if commands[command].nil?
        puts "Wrong command"
      else
        commands[command].run(args: args, cli: self)
      end
    end
  end

  # Returns the commands object
  # @return [Hash{String => Command}]
  def commands
    @@commands
  end

  # Runs a command and exits if succesful
  def run_only(args)
    parser = ArgsParser.new
    # TODO parse cmdline arguments
    puts parser.parser.to_s
    exit(1)
    # end
  end

  # Loads students to memory, raises error if file cannot be read
  # @param students_json [String] Students JSON file
  # @return [Hash{ String => String }] Hash of name => id
  def load_students(students_json:)
    if File.readable?(students_json)
      File.open(students_json) do |file|
        # Parse students into a hash of name=>id
        JSON.parse(file.read).each_with_object({}) do |student, hash|
          hash[student["name"]] = student["id"]
        end
      end
    else
      # Couldn't read students file
      raise "Could not read students list file"
    end
  end
end

# check if app was started with parameters
if ARGV.length > 1
  StudyGroupUtils.new.run_only(ARGV)
else
  StudyGroupUtils.new.start
end
