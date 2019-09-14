#require "bundler/gem_tasks"
require 'dotenv/tasks'
require "rspec/core/rake_task"
require 'open3'
require 'os'
require 'json'
require 'fileutils'

## TODO:
# Implement command:
# autorest --package-name=haipa_compute D:\Source\Repos\Haipa\haipa-api-spec\specification\readme.md --namespace=Haipa::Client::Compute::V1_0 --tag=v1 --package-version=0.0.1 --output-folder=D:/fwagner/Documents/ruby/haipa-client/core/haipa_compute/lib/ --use=D:\Source\Repos\Haipa\autorest.ruby --ruby --haipa


def get_config_files_folder
    "#{__dir__}/config"
  end

gem_versions = JSON.parse(File.read(File.expand_path("#{get_config_files_folder}/GEM_VERSIONS", __FILE__)).strip)

desc 'run specs for each of the projects'
task :spec, [:gem_name] => :dotenv do |_, args|
  each_gem do |gem_dir|
    if !should_i_continue(args[:gem_name], gem_dir)
      next
    end

    puts "Executing spec on #{gem_dir}"
    execute_and_stream('bundle install')
    execute_and_stream('bundle exec rspec')
  end
end


desc 'Delete multiple version folders for each sdk'
task :clean_generated, [:gem_name] do |_, args|
  clean_generated('core', args[:gem_name])
  Dir.chdir(File.expand_path('..', __FILE__))
end

task :regen_folder_structure_if_required, [:gem_name] do |_, args|
    if args[:gem_name]
      component = 'core'
      command = "ruby #{__dir__}/generators/metadatagen/src/metadatagen.rb --component=#{component} --gem_name=#{args[:gem_name]} --root_path=#{__dir__}"
      execute_and_stream(command)
    end
end

task :regen_sdk_versions, [:gem_name] => [:regen_folder_structure_if_required, :clean_generated] do |_, args|
    json = get_config_file
    each_gem do |dir| # dir corresponds to each client folder
     
      puts "\nGenerating #{dir}\n"
      ar_base_command = "#{ENV.fetch('AUTOREST_LOC', 'autorest')}"
      ar_base_command = "#{ar_base_command} --use=#{ENV.fetch('AUTOREST_RUBY_LOC')}" unless ENV.fetch('AUTOREST_RUBY_LOC', nil).nil?
      puts "ar_base_command #{ar_base_command}"
      md = json[dir] # there should be an entry in the metadata for each of the api versions to generate
      package_name = dir
      component = get_component(dir)
      md.each do |api_version_pkg, api_version_value|
        ar_arguments = ''
        output_folder = ''
        api_version_value.each do |argument_name, argument_value|
          if argument_name.casecmp("output-folder") == 0
            output_folder = argument_value
          else
            if argument_name.casecmp("package-name") == 0
              package_name = argument_value
            else
              if argument_name.casecmp("markdown") == 0
                ar_arguments = ar_arguments + " #{argument_value}"
              else
                if argument_name.casecmp("input-file") == 0
                  input_files = argument_value.map {|file| "--input-file=#{file}"}
                  ar_arguments = ar_arguments + input_files.join(" ")
                else
                  ar_arguments = ar_arguments + " --#{argument_name}=#{argument_value}"
                end
              end
            end
          end
        end
        command = "#{ar_base_command} --package-name=#{package_name} #{ar_arguments} --package-version=#{gem_versions[component][dir]} --output-folder=#{File.join(Dir.pwd, 'lib', output_folder)} --haipa --ruby"
        execute_and_stream(command)
      end
      update_gem_version('lib/version.rb', gem_versions[component][dir])
    end
  end

  task :default => :spec


  def execute_and_stream(cmd)
    puts "running: #{cmd}"
    execute(cmd)
  end

  def execute(cmd)
    Open3.popen2e(cmd) do |_, stdout_err, wait_thr|
      while line = stdout_err.gets
        puts line
      end
  
      exit_status = wait_thr.value
      unless exit_status.success?
        abort "FAILED !!!"
      end
    end
  end

  def get_config_file
    config_file = File.read(File.expand_path("#{get_config_files_folder}/config.json", __FILE__))
    JSON.parse(config_file)
  end

  def each_child_for_component(parent_dir, change_dir = true)
    Dir.chdir(File.expand_path("../#{parent_dir}", __FILE__))
    sub_dirs = Dir['*'].reject{|o| not File.directory?(o)}
    sub_dirs.each do |dir| 
      if (change_dir)
        Dir.chdir(dir) do
          yield(dir)
        end
      else
        yield dir
      end
    end
  end

  def get_component(dir)
    component = 'core'
    component
  end

  def each_gem
    each_child do |dir|
      gem_dir = dir.split('/').last
      yield gem_dir
    end
  end

  def should_i_continue(key, dir)
    return (key.nil? || key == dir)
  end

  def each_child
    each_child_for_component('core') {|dir| yield dir }
  end

  def clean_generated(parent_dir, key)
    Dir.chdir(File.expand_path("../#{parent_dir}", __FILE__))
    gem_folders = Dir['*'].reject{|o| not File.directory?(o)}
    gem_folders.each do |gem|
      if !should_i_continue(key, gem)
        next
      end

      Dir.chdir(File.expand_path("../#{parent_dir}/#{gem}/lib", __FILE__))
      subdir_list = Dir['*'].reject{|o| not File.directory?(o)}
      subdir_list.each do |subdir|
  
        folder_to_be_cleaned = File.expand_path("../#{parent_dir}/#{gem}/lib/#{subdir}", __FILE__)
        puts "Cleaning folder - #{folder_to_be_cleaned}"
        FileUtils.rm_rf(folder_to_be_cleaned)
      end
    end
  end

  def update_gem_version(version_file, new_version)
    existing_contents =  File.read(version_file)
    content_to_replace = existing_contents.gsub(/VERSION = '.*'/, "VERSION = '#{new_version}'")
    File.open(version_file, 'w') { |file| file.puts content_to_replace }
  end
  