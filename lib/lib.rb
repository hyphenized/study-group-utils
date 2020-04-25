require 'readline'
Dir[File.expand_path("./**/*.rb", File.dirname(__FILE__))].each(&method(:require))

# Reads commands from the CLI
class Interpreter
  # @param cli [CLI]
  def initialize(cli)
    # Load all commands
    load_commands
    load_basic_commands

    #p $_commands
    $_commands["help"].run(cli: cli)
    while input = Readline.readline("> ", true)
      system('clear') || system('cls')
      input.strip.sub!(/^(\w+)\s*/, '')
      p command = $1
      #puts "your input: #{command}"
      if $_commands.keys.include? command
        $_commands[command].run(args: input, cli: cli )
      end
    end
  end

  def load_commands
    # @type [Hash{String => Command}]
    $_commands = Hash.new(nil)
    Dir["commands/*.rb"].each do |file|
      load(file, true)
    end

    $_commands.transform_keys! do |key|
       File.basename(key).sub(/#{File.extname(key)}$/, '')
    end
  end

  def load_basic_commands
    $_commands["help"] = BasicCommands::Help.new
    $_commands["exit"] = BasicCommands::Exit.new
  end
end