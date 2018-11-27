# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zapp_sdk_tasks/version"

Gem::Specification.new do |spec|
  spec.name          = "zapp_sdk_tasks"
  spec.version       = ZappSdkTasks::VERSION
  spec.authors       = ["Ran Meirman"]
  spec.email         = ["r.meirman@applicaster.com"]

  spec.summary       = "Zapp sdks related common tasks"
  spec.homepage      = "https://github.com/applicaster/zapp-sdk-tasks"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-s3", "~> 1"
  spec.add_dependency "faraday", "~> 0.15.3"
  spec.add_dependency "rake", "~> 11.0"
  spec.add_dependency "versionomy", "~> 0.5.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "dotenv", "~> 2.5.0"
  spec.add_development_dependency "fantaskspec", "~> 1.0.0"
  spec.add_development_dependency "pry", "~> 0.12.1"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4.1"
  spec.add_development_dependency "rubocop", "~> 0.60.0"
end
