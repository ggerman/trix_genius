require "rails/generators"

module TrixGenius
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        initializer "trix_genius", <<~RUBY
          TrixGenius.configure do |config|
            config.deepseek_api_key=ENV['DEEPSEEK_API_KEY']
          end
        RUBY
      end

      def update_applications_js
        # app/javascript/application.js

        # import "controllers"
        # import "trix"
        # import "@rails/actiontext"


        # app/javascript/controllers/application.js
        # import TrixController from "controllers/trix-controller"
        # application.register("trix", TrixController)
      end

      def create_stimulus_controller
        copy_file "trix_genius_controller.js", "app/javascript/controllers/trix_genius_controller.js"
      end

    end
  end
end
