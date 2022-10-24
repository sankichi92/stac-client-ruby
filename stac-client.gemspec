# frozen_string_literal: true

require_relative "lib/stac/client/version"

Gem::Specification.new do |spec|
  spec.name = "stac-client"
  spec.version = Stac::Client::VERSION
  spec.authors = ["Takahiro Miyoshi"]
  spec.email = ["takahiro-miyoshi@sankichi.net"]

  spec.summary = "A client for working with STAC Catalogs and APIs"
  spec.homepage = "https://github.com/sankichi92/stac-client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sankichi92/stac-client"
  spec.metadata["changelog_uri"] = "https://github.com/sankichi92/stac-client/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "stac", "~> 0.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
