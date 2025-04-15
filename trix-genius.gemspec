Gem::Specification.new do |s|   
  s.name        = "trix-genius"   
  s.version     = "0.1.4"
  s.summary     = "Integrates AI-powered buttons with Trix using Stimulus"
  s.description = "Trix-Genius adds AI-powered buttons and other custom controls to Trix editor using Stimulus."
  s.authors     = ["Giménez Silva Germán Alberto"] 
  s.email       = "ggerman@gmail.com"
  s.files       = Dir["lib/**/*", "generators/**/*","templates/**/*", "spec/**/*"]
  s.require_paths = ["lib"]
  s.homepage      = "https://rubystacknews.com/2025/04/15/%f0%9f%9a%80-introducing-trixgenius-alpha-0-1-2-now-with-ai-powered-math-evaluation/"
  s.license     = "GNU"

  s.required_ruby_version = "~> 3.0"

  s.add_dependency "rails", ">= 6.0", "< 9.0"
  s.add_dependency "stimulus-rails", "~> 1.3"
  s.add_dependency "actiontext", "~> 8.0"
  s.add_dependency "faraday", "~> 2.12"
  s.add_dependency "yaml"

  s.add_development_dependency "rspec"
  s.add_development_dependency "generator_spec", "~> 3.0"

  s.metadata = {
    "source_code_uri" => "https://github.com/ggerman/trix_genius",
    "changelog_uri"   => "https://github.com/ggerman/trix_genius/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://github.com/ggerman/trix_genius/blob/develop/README.md",
    "bug_tracker_uri" => "https://github.com/ggerman/trix_genius/blob/main/CHANGELOG.md",
    "homepage_uri"    => "https://rubystacknews.com/",
    "wiki_uri"        => "https://github.com/ggerman/trix_genius/wiki",
  }
end





