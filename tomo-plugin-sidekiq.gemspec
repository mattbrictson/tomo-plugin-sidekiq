require_relative "lib/tomo/plugin/sidekiq/version"

Gem::Specification.new do |spec|
  spec.name = "tomo-plugin-sidekiq"
  spec.version = Tomo::Plugin::Sidekiq::VERSION
  spec.authors = ["Matt Brictson"]
  spec.email = ["opensource@mattbrictson.com"]

  spec.summary = "sidekiq tasks for tomo"
  spec.homepage = "https://github.com/mattbrictson/tomo-plugin-sidekiq"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/mattbrictson/tomo-plugin-sidekiq/issues",
    "changelog_uri" => "https://github.com/mattbrictson/tomo-plugin-sidekiq/releases",
    "source_code_uri" => "https://github.com/mattbrictson/tomo-plugin-sidekiq",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tomo", "~> 1.0"
end
