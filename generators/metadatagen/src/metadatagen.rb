# encoding: utf-8
# Copyright (c) dbosoft GbmH. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'erb'
require 'json'
require_relative 'metadatagen_options_parser'
require 'fileutils'

class MetaDataGenerator
  def initialize(component, gem_name, root_path)
    @component = component
    @gem_name = gem_name
    @root_path = root_path
  end

  def copy_file(file_name, destination)
    FileUtils.copy("#{@root_path}/generators/metadatagen/src/resources/#{file_name}", destination)
  end

  def check_and_create_directory(directory_path)
    if !File.directory?(directory_path)
      FileUtils.mkdir directory_path
    end
  end

  def check_and_create_file(check_path, resource_file_name, destination)
    if !FileTest.exist?(check_path)
      copy_file(resource_file_name, destination)
    end
  end

  def process
    check_and_create_directory "#{@root_path}/#{@component}/#{@gem_name}"
    check_and_create_directory "#{@root_path}/#{@component}/#{@gem_name}/spec"
    check_and_create_directory "#{@root_path}/#{@component}/#{@gem_name}/lib"
 
    check_and_create_file("#{@root_path}/#{@component}/#{@gem_name}/.rspec", '.rspec', "#{@root_path}/#{@component}/#{@gem_name}")
    check_and_create_file("#{@root_path}/#{@component}/#{@gem_name}/LICENSE.txt",'LICENSE.txt', "#{@root_path}/#{@component}/#{@gem_name}")
    check_and_create_file("#{@root_path}/#{@component}/#{@gem_name}/Rakefile", 'Rakefile', "#{@root_path}/#{@component}/#{@gem_name}")
    spec_entries = Dir.entries "#{@root_path}/#{@component}/#{@gem_name}/spec"
    spec_entries.delete "."
    spec_entries.delete ".."
    if spec_entries.empty?
      check_and_create_file("#{@root_path}/#{@component}/#{@gem_name}/spec/spec_helper.rb", 'spec_helper.rb', "#{@root_path}/#{@component}/#{@gem_name}/spec")
    end
    check_and_create_file("#{@root_path}/#{@component}/#{@gem_name}/lib/#{@gem_name}.rb",'require_file.rb', "#{@root_path}/#{@component}/#{@gem_name}/lib/#{@gem_name}.rb")

    @module_name = get_module_name

    if !FileTest.exist?("#{@root_path}/#{@component}/#{@gem_name}/lib/module_definition.rb")
      module_definition_file = get_module_definition_file
      module_definition_file.write(get_renderer(get_module_definition_renderer_template))
    end

    if !FileTest.exist?("#{@root_path}/#{@component}/#{@gem_name}/lib/version.rb")
      version_file = get_version_file
      version_file.write(get_renderer(get_version_renderer_template))
    end

    if !FileTest.exist?("#{@root_path}/#{@component}/#{@gem_name}/#{@gem_name}.gemspec")
      gemspec_file = get_gemspec_file
      gemspec_file.write(get_renderer(get_gemspec_renderer_template))
    end
  end

  def get_module_name
    gem_array = @gem_name.split '_'
    if @component == 'enterprise'
      index = 2
    else
      index = 1
    end

    module_name = ''
    gem_array[index..gem_array.length-1].each do |element|
      module_name.concat(element.capitalize)
    end

    module_name
  end

  def get_module_definition_renderer_template
    File.read("#{@root_path}/generators/metadatagen/src/resources/templates/module_definition_template.template")
  end

  def get_version_renderer_template
    File.read("#{@root_path}/generators/metadatagen/src/resources/templates/version_template.template")
  end

  def get_gemspec_renderer_template
    File.read("#{@root_path}/generators/metadatagen/src/resources/templates/gemspec_template.template")
  end

  def get_module_definition_file
    File.new("#{@root_path}/#{@component}/#{@gem_name}/lib/module_definition.rb", 'w')
  end

  def get_version_file
    File.new("#{@root_path}/#{@component}/#{@gem_name}/lib/version.rb", 'w')
  end

  def get_gemspec_file
    File.new("#{@root_path}/#{@component}/#{@gem_name}/#{@gem_name}.gemspec", 'w')
  end

  def get_renderer(template)
    renderer = ERB.new(template, 0, '-%>')
    renderer.result(get_binding)
  end

  def get_binding
    binding
  end
end

options = MetaDataGeneratorOptionsParser.options ARGV
obj = MetaDataGenerator.new(options.component, options.gem_name,options.root_path)
obj.process