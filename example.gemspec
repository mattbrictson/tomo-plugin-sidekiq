lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tomo/plugin/example/version"

Gem::Specification.new do |spec|
  spec.name          = "example"
  spec.version       = Tomo::Plugin::Example::VERSION
  spec.authors       = ["Example Owner"]
  spec.email         = ["owner@example.com"]

  spec.summary       = ""
  spec.homepage      = "https://github.com/mattbrictson/tomo-plugin"
  spec.license       = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/mattbrictson/tomo-plugin/issues",
    "changelog_uri" => "https://github.com/mattbrictson/tomo-plugin/releases",
    "source_code_uri" => "https://github.com/mattbrictson/tomo-plugin",
    "homepage_uri" => "https://github.com/mattbrictson/tomo-plugin"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = `git ls-files -z exe lib LICENSE.txt README.md`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "tomo"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "minitest-ci", "~> 3.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "0.75.0"
  spec.add_development_dependency "rubocop-performance", "1.5.0"
end
