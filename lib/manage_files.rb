require 'json'
require 'yaml'
require 'csv'

# Encoding.default_external = "UTF-8"

class ReadFile
  attr_accessor :file_name, :type, :file

  def initialize(file_name)
    @file_name = file_name
    @type = file_name.split('.')[-1]
    @file = valid_file
  end

  def valid_file
    file_obj_name = "#{file_name}"
    if File.exist?(file_obj_name)
      file_obj_name
    else
      msg = 'Sorry, but we could not find this file'
      puts msg
      nil
      raise ArgumentError, msg
    end
  end

  def read
    file_obj_read = File.read(file)
    case type
    when 'json' then JSON.parse(file_obj_read)
    when 'yaml' then YAML.load_file(file)
    when 'csv'  then CSV.read(file, headers: true, encoding: "UTF-8")
    end
  end

  def write
    case type
    when 'json'
      tempHash = {
        "key_a" => "val_a",
        "key_b" => "val_b",
      }
      File.open(file, 'w') do |f|
        f.write(tempHash.to_json)
      end
    when 'yaml'
    when 'csv'
    end
  end

  def import
    case type
    when 'json'
    when 'yaml'
    when 'csv'
    end
  end

  def export
    case type
    when 'json'
    when 'yaml'
    when 'csv'
    end
  end
end

# ------------
# ReadFile.new('abc.json')
# ReadFile.new('students.json').read.map { |studen| p studen }
# ReadFile.new('abc.yaml').read.map { |item| p item }
# ReadFile.new('./past_groups/week6.csv').read.map { |item| p item }

# Returns a hash of students and pull requests
# @return hash [Hash{String => Array}]
# @param students [Hash{String => String}]
#def match_code_reviews(students)
#  students.
#end
#
#x = parser
#
#