# encoding: utf-8
# Copyright (c) dbosoft GmbH. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'optparse'
require 'ostruct'

#
# Command line options parser for the generation
# of require files.
#
# Options
#    -h, --help : Displays help for the require files generator
#    -p, --component : Core/Enterprise Component
#    -s, --root_path : Path to ruby-client
#    -g, --gem_name: Name of the gem
#

class MetaDataGeneratorOptionsParser
  def self.parse(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: metadatagen.rb [options]'

      opts.on('-cCOMPONENT', '--component=COMPONENT', 'Core/Enterprise Component') do |component|
        if (component != 'core' && component != 'enterprise')
          raise OptionParser::InvalidOption.new('component must be core/enterprise')
        end
        options.component = component
      end

      opts.on('-rROOT_PATH', '--root_path=ROOT_PATH', 'Root Path') do |root_path|
        options.root_path = root_path
      end

      opts.on('-gGEM_NAME', '--gem_name=gGEM_NAME', 'Gem Name') do |gem_name|
        options.gem_name = gem_name
      end

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end

  #
  # Gets the parsed command line options.
  #
  def self.options(args)
    args << '-h' if args.empty?
    options = self.parse(args)
    mandatory_params = [:component, :gem_name, :root_path]
    missing_params = mandatory_params.select{|param| options[param].nil?}
    raise OptionParser::MissingArgument.new(missing_params.join(', ')) unless missing_params.empty?
    options
  end
end
