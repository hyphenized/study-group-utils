require 'optparse'

class ArgsParser
  attr_accessor :parser
  def initialize
    @options = {}
    @parser = OptionParser.new do |opts|
      options = @options
      opts.banner = <<~BANNER
      Usage: study-utils.rb <command> [options]

        available commands:
        match           Match students for code reviews
        group           Generate study groups

      BANNER

      # opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      #  options[:verbose] = v
      # end

      opts.on("-f FORMAT", "--format=FORMAT", "Output format, either json, yaml or csv") do |custom_format|
        unless %w(json csv yaml).include? custom_format
          raise OptionParser::InvalidOption, "Invalid format"
        end
        options[:format] = custom_format
      end

      opts.on("-o FILENAME", "--output=FILENAME", "Output filename") do |v|
        options[:file_name] = v
        p v
      end

      opts.on("-g SIZE", "--group=SIZE", "Group size") do |n|
        options[:group_size] = n
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit(1)
      end
    end
  end

  # Gets parameters from ARGV or exits with usage info if invalid params
  def parse
    parser.parse(ARGV)
    @options
  rescue OptionParser::InvalidOption => e
    puts e
    puts parser
    #p @options
    exit(1)
  end
end

#options = ArgsParser.new.parse
#p options