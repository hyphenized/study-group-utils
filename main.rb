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
  DEFAULT_CONFIG = {
    "past_files_prefix" => "week",
    "past_files_format" => "csv",
    "past_files_folder" => "past_groups",
    "past_assignments_folder" => "past_assignments",
    "student_list" => "students.json",
    "group_size" => 3,
    "verbose" => true,
  }.freeze

  attr_reader :students, :past_groups, :past_assignments, :group_size, :config

  def initialize
    load_config
    load_students
    load_past_groups
    load_past_assignments
    @group_size = @config["group_size"]

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

  # Loads CLI config
  def load_config
    @config = DEFAULT_CONFIG.merge
    if File.readable?("_config.json")
      @config = @config.merge(JSON.parse(File.read('_config.json')))
    end
  end

  # Loads students to memory, raises error if file cannot be read
  def load_students
    students_file = @config["student_list"]
    if File.readable?(students_file)
      File.open(students_file) do |file|
        # Parse students into a hash of name=>id
        @students = JSON.parse(file.read).map do |hash|
          [hash["name"], hash["id"]]
        end
        @students = Hash[@students]
      end
    else
      # Couldn't read students file
      raise "Could not read students list file"
    end
  end

  # Returns past_groups
  def load_past_groups
    past_groups_folder = @config["past_files_folder"]
    return [] unless File.directory?(past_groups_folder)

    @past_groups = Dir["#{past_groups_folder}/*.csv"].map do |filename|
      ReadFile.new(filename).read.group_by { |row| row["study_group"] }
    end
  end

  def load_past_assignments
    past_assignments_folder = @config["past_assignments_folder"]
    return [] unless File.directory?(past_assignments_folder)

    @past_assignments = Dir["#{past_assignments_folder}/*.json"].map do |filename|
      ReadFile.new(filename).read.group_by { |assignment| assignment["assignmentName"] }
    end.
      reduce({}) { |hash, assignment_data| hash.merge assignment_data }
  end

  ##
end

CLI.new
