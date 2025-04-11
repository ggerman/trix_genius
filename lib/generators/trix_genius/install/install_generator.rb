require "rails/generators"
require "trix_genius/flexible_injector"

module TrixGenius
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        template "trix_genius.rb", File.join(destination_root, "config/initializers/trix_genius.rb")
      end

      def add_import_to_application_js
        js_application_path = "app/javascript/application.js"
        js_application_path = File.join(destination_root, js_application_path)
        unless File.exist?(js_application_path)
          puts javascript_application_msg 
          say_status("error", "Could not find #{js_application_path}", :red)
        end

        js_application_controller_path = "app/javascript/controllers/application.js"
        js_application_controller_path = File.join(destination_root, js_application_controller_path)
        unless File.exist?(js_application_controller_path)
          puts javascript_application_controller_msg
          say_status("error", "Could not find #{js_application_controller_path}", :red)
        end

        gem_root = File.expand_path("../..", __dir__)
        config_path = File.join("config", "setting_updates.yml")
        FlexibleInjector.start([config_path, destination_root])
      end

      def create_stimulus_controller
        template "trix_genius_controller.js", File.join(destination_root, "app/javascript/controllers/trix_genius_controller.js")
      end

      def add_route_to_routes_file
        route_code = ["",
              "  # TrixGenius: Auto-added route",
              '  post "/trix_genius/correct_spelling", to: "trix_genius#correct_spelling"',
              ""].join("\n")

        inject_into_file File.join(destination_root, "config/routes.rb"), route_code, after: "Rails.application.routes.draw do\n"
      end

      def create_controller
        template "trix_genius_controller.rb", File.join(destination_root, "app/controllers/trix_genius_controller.rb")
      end

      protected

      def javascript_application_msg
          <<~MSG

            ⚠️  You should create the file manually:

            📄 app/javascript/application.js

            💡 With the following content:

            // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
            import "@hotwired/turbo-rails"
            import "controllers"

            import "trix"
            import "@rails/actiontext"

          MSG
      end

      def javascript_application_controller_msg
        <<~MSG

          ⚠️  You should create the file manually:

          📄 app/javascript/controllers/application.js

          💡 With the following content:

          import { Application } from "@hotwired/stimulus"
          import TrixController from "controllers/trix-controller"

          const application = Application.start()

          // Configure Stimulus development experience
          application.debug = false
          window.Stimulus   = application

          application.register("trix", TrixController)

          export { application }
        MSG

      end

    end
  end
end
