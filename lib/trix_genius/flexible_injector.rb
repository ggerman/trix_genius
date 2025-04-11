require 'yaml'
require 'thor'
require 'thor/actions'

module TrixGenius
  class FlexibleInjector < Thor::Group
    include Thor::Actions
    argument :file_name, type: :string
    argument :base_path, type: :string

    def self.source_root
      Dir.pwd
    end

    def apply_from_config
      injections = YAML.load_file(file_name)

      injections.each do |injection|
        file_path = injection['file']
        content   = "\n" + injection['content'] + "\n"
        message   = (injection['message'] || 'insert').to_sym
        options   = {}
        options[:after]  = injection['after'] if injection['after']
        options[:before] = injection['before'] if injection['before']

        complete_path = File.join(base_path, file_path)

        case message
        when :insert
          say_status :insert, complete_path
          inject_into_file(complete_path, content, options)
        when :append
          say_status :append, complete_path
          inject_into_file(complete_path, content)
        else
          say_status :skip, "#{complete_path} — unknown message: #{message}", :yellow
        end

      end

    end
  end
end

