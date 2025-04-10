require "rails/generators"

module TrixGenius
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        template "trix_genius.rb", File.join(destination_root, "config/initializers/trix_genius.rb")
      end

      def add_import_to_application_js
        create_file "verbose.log", "DEST: #{destination_root}"

        js_application_path = "app/javascript/application.js"
        js_application_path = File.join(destination_root, js_application_path)
        application_lines = []
        application_lines << "// Trix Genius block\n"
        application_lines << "import \"controllers\""
        application_lines << "import \"trix\""
        application_lines << "import \"@rails/actiontext\"\n\n"

        if File.exist?(js_application_path)
          application_file = File.read(js_application_path)
          update_js_file(application_lines, application_file, js_application_path)
        else
          say_status("error", "Could not find #{js_application_path}", :red)
        end


        js_application_controller_path = "app/javascript/controllers/application.js"
        js_application_controller_path = File.join(destination_root, js_application_controller_path)
        application_controller_lines = []
        application_controller_lines << "// Trix Genius block"
        application_controller_lines << "import TrixGeniusController from \"controllers/trix_genius_controller\""
        application_controller_lines << "application.register(\"TrixGenius\", TrixGeniusController)\n\n"

        if File.exist?(js_application_controller_path)
          application_controller_file = File.read(js_application_controller_path)
          update_js_file(application_controller_lines, application_controller_file, js_application_controller_path, false)
        else
          say_status("error", "Could not find #{js_application_controller_path}", :red)
        end
      end

      def create_stimulus_controller
        template "trix_genius_controller.js", File.join(destination_root, "app/javascript/controllers/trix_genius_controller.js")
      end

      protected

      def update_js_file(lines, content, path, append=true)
        row = content.lines
        lines.each do |line|
          unless content.include?(line)
            if append
              append_to_file path, "\n#{line}"
            else
              row.insert(-2, "\n#{line}")
              create_file path, row.join, force: true
            end
          else
            say_status("skipped", "Import already present in application.js", :yellow)
          end
        end
      end 
    end
  end
end
