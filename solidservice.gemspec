# frozen_string_literal: true

require_relative "lib/solidservice/version"

Gem::Specification.new do |spec|
  spec.name = "solidservice"
  spec.version = SolidService::VERSION
  spec.authors = ["Hopper Gee"]
  spec.email = ["hopper.gee@hey.com"]

  spec.summary = "Service object with a simple API"
  spec.description = "Service object with a simple API"
  spec.homepage = "https://github.com/hoppergee/solidservice"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hoppergee/solidservice"
  spec.metadata["changelog_uri"] = "https://github.com/hoppergee/solidservice/blob/main/CHANGELOG.md"

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
  spec.add_dependency "activesupport", "> 5"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
