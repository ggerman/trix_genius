require "spec_helper"
require "generator_spec"
require "generators/trix_genius/install/install_generator"
require "pry"


RSpec.describe TrixGenius::Generators::InstallGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp/dummy_app", __FILE__)

  before(:all) do
    prepare_destination

    # Create application.js to simulate existing file
    initializer_rb = File.join(destination_root, "config/initialize/trix_genius.rb")
    js_path = File.join(destination_root, "app/javascript/application.js")
    js_controller_path = File.join(destination_root, "app/javascript/controllers/application.js")

    FileUtils.mkdir_p(File.dirname(js_path))
    File.write(js_path, <<~JS)
      import "controllers"
    JS

    FileUtils.mkdir_p(File.dirname(js_controller_path))
    File.write(js_controller_path, <<~JS)
      import { Application } from "@hotwired/stimulus"
      const application = Application.start()
      // Configure Stimulus development experience
      application.debug = false
      window.Stimulus   = application
      export { application }
    JS
  end

  it "creates the initializer" do
    run_generator
    assert_file "config/initializers/trix_genius.rb"
  end

  it "updates application.js with import line" do
    run_generator
    assert_file "app/javascript/application.js" do |content|
      expect(content).to include('import "trix"')
      expect(content).to include('import "@rails/actiontext"')
    end
  end

  it "updates controller application.js with import line" do
    run_generator
    assert_file "app/javascript/controllers/application.js" do |content|
      expect(content).to include('import TrixController from "controllers/trix-controller"')
      expect(content).to include('application.register("trix", TrixController)')
    end
  end

  it "creates the trix_genius_controller.js file" do
    run_generator
    assert_file "app/javascript/controllers/trix_genius_controller.js"
  end
end
