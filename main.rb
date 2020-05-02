require 'json'
require 'yaml'
require 'csv'
require 'readline'
require_relative 'lib/lib.rb'

Encoding.default_external = "UTF-8"
# trap "SIGINT" do
#  puts "tried to exit"
# exit
# end

# Starts as CLI or Runs a command and exits
class CLI
  attr_reader :students, :config

  def initialize
    @config = CLIConfig.load
    @students = load_students(students_json: @config["student_list"])

    # check if app was started with parameters
    if ARGV.length > 0
      run_only ARGV.shift
    else
      puts "Entering CLI mode..."
      Interpreter.new(self)
    end
  end

  # Runs a command and exits if succesful
  # @param cmd [String] command name
  def run_only(cmd)
    parser = ArgsParser.new
    case cmd
    when "match", "group"
      options = parser.parse
    else
      puts parser.parser.to_s
      exit(1)
    end
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

CLI.new
