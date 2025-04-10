require "spec_helper"
require "generator_spec"
require "generators/trix_genius/install/install_generator"
require "stringio"

require "pry"

RSpec.describe TrixGenius::Generators::InstallGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp/dummy_app", __FILE__)

  before(:all) do
    prepare_destination

    routes_path = File.join(destination_root, "config/routes.rb")
    FileUtils.mkdir_p(File.dirname(routes_path))
    File.write(routes_path, <<~RUBY)
              Rails.application.routes.draw do
                resources :posts
                # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

                # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
                # Can be used by load balancers and uptime monitors to verify that the app is live.

                # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
                # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
                # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

                # Defines the root path route ("/")
                # root "posts#index"
              end
    RUBY

    js_path = File.join(destination_root, "app/javascript/application.js")
    js_controller_path = File.join(destination_root, "app/javascript/controllers/application.js")

    FileUtils.mkdir_p(File.dirname(js_path))
    File.write(js_path, <<~JS)
      import "@hotwired/turbo-rails"
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

  it "Should creates the initializer" do
    run_generator
    assert_file "config/initializers/trix_genius.rb"
  end

  it "Should updates application.js with import line" do
    run_generator
    assert_file "app/javascript/application.js" do |content|
      expect(content).to include('import "trix"')
      expect(content).to include('import "@rails/actiontext"')
    end
  end

  it "Should updates controller application.js with import line" do
    run_generator
    assert_file "app/javascript/controllers/application.js" do |content|
      expect(content).to include('import TrixController from "controllers/trix_genius_controller"')
      expect(content).to include('application.register("trix", TrixController)')
    end
  end

  it "Should creates the trix_genius_controller.js file" do
    run_generator
    assert_file "app/javascript/controllers/trix_genius_controller.js"
  end

  it "Should creates the trix_genius_controller.rb file" do
    run_generator
    assert_file "app/controllers/trix_genius_controller.rb"
  end

  it "Should add route to trix functionality" do
    run_generator
    assert_file "config/routes.rb" do |content|
      expect(content).to include('post "/trix_genius/correct_spelling", to: "trix_genius#correct_spelling"')
    end
  end

=begin
  ready to catch terminal resulto to create the Spec when application.js does't exist

  it "Should launch error because app/javascript/application.js doesn't exist" do
    js_path = File.join(destination_root, "app/javascript/application.js")
    FileUtils.rm_f(js_path)

    output = capture_stdout { run_generator }

    binding.pry
    expect(output).to include("You should create the file manually:")
    expect(output).to include("app/javascript/application.js")
    expect(output).to include("import \"trix\"")
    expect(output).to include("Could not find #{js_path}")
  end

  def capture_stdout
    previous_stdout = $stdout
    fake = StringIO.new
    $stdout = fake
    yield
    fake.string
  ensure
    $stdout = previous_stdout
  end
 
=end

end
