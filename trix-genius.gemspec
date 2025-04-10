Gem::Specification.new do |s|   
  s.name        = "trix-genius"   
  s.version     = "0.1.0"
  s.summary     = "Integrates AI-powered buttons with Trix using Stimulus"
  s.description = "Trix-Genius adds AI-powered buttons and other custom controls to Trix editor using Stimulus."
  s.authors     = ["Giménez Silva Germán Alberto https://rubystacknews.com/"] 
  s.email       = "ggerman@gmail.com"
  s.files       = Dir["lib/**/*", "generators/**/*","templates/**/*", "spec/**/*"]
  s.require_paths = ["lib"]
  s.homepage    = "https://rubystacknews.com/"   
  s.license     = "GNU"

  s.required_ruby_version = ">= 3.0"

  s.add_dependency "rails", ">= 6.0", "< 9.0"
  s.add_dependency "stimulus-rails", "~> 1.3"
  s.add_dependency "actiontext", "~> 8.0"
  s.add_dependency "faraday", "~> 2.12"

  s.add_development_dependency "generator_spec"
end
