require "zapp_sdk_tasks/version"

module ZappSdkTasks
end

if defined?(Rails)
  module ZappSdkTasks
    class Railtie < ::Rails::Railtie
      railtie_name :zapp_sdk_tasks

      rake_tasks do
        path = File.expand_path(__dir__)
        Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
      end
    end
  end
end
