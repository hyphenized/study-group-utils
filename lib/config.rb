# Manages the CLI Config

class CLIConfig
  DEFAULT_CONFIG = {
    "past_files_prefix" => "week",
    "past_files_format" => "csv",
    "past_files_folder" => "past_groups",
    "past_assignments_folder" => "past_assignments",
    "student_list" => "students.json",
    "group_size" => 3,
    "verbose" => true,
  }.freeze

  # Loads CLI config
  def self.load
    default = DEFAULT_CONFIG.dup
    if File.readable?("_config.json")
      default.merge(JSON.parse(File.read('_config.json')))
    else
      default
    end
  end
end
