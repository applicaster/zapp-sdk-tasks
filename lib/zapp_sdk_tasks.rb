# frozen_string_literal: true

require "zapp_sdk_tasks/version"

module ZappSdkTasks
  include Rake::DSL if defined? Rake::DSL

  path = File.expand_path(__dir__)
  $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "lib"))
  Dir.glob("#{path}/**/*.rake").each { |f| load f }
end

if defined?(Rails)
  module ZappSdkTasks
    class Railtie < ::Rails::Railtie
      railtie_name :zapp_sdk_tasks

      rake_tasks do
        path = File.expand_path(__dir__)
        $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "lib"))
        Dir.glob("#{path}/**/*.rake").each { |f| load f }
      end
    end
  end
end
