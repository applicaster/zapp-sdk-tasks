# frozen_string_literal: true

require "bundler/setup"
require "zapp_sdk_tasks"
require "fantaskspec"
require "rake"
require "pry"

RSpec.configure do |config|
  $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
  Dir.glob("lib/**/*.rake").each { |f| load f }

  config.infer_rake_task_specs_from_file_location!
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
