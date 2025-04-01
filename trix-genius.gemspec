Gem::Specification.new do |s|   
  s.name        = "trix-genius"   
  s.version     = "0.0.5"
  s.summary     = "Integrates AI-powered buttons with Trix using Stimulus"
  s.description = "Trix-Genius adds AI-powered buttons and other custom controls to Trix editor using Stimulus."
  s.authors     = ["Giménez Silva Germán Alberto https://rubystacknews.com/"] 
  s.email       = "ggerman@gmail.com"
  s.files       = Dir["lib/**/*", "templates/**/*"]
  s.homepage    = "https://rubystacknews.com/"   
  s.license     = "GNU"
  s.add_dependency "rails", ">= 6.0"
  s.add_dependency "stimulus-rails", ">= 1.3.4"
  s.add_dependency "actiontext", ">= 8.0"
end
