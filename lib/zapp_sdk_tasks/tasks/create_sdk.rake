# frozen_string_literal: true

require "faraday"
require "versionomy"
require "logger"
require "git_helper"
require "sdk_helper"

desc "Create SDK version on Zapp"
namespace :zapp_sdks do
  task :create, :platform, :version, :project_repo_name, :zapp_token do |_task, args|
    connection = Faraday.new(url: SdkHelper.zapp_host) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger, ::Logger.new(STDOUT), bodies: true do |logger|
        logger.filter(/(access_token=)(\w+)/, "\1[REMOVED]")
      end

      faraday.adapter Faraday.default_adapter
    end

    unless %i[release preview final].include?(SdkHelper.release_type(args[:version]))
      puts "skipping sdk creation, version #{args[:version]} should not be published"
      next
    end

    response = connection.post(SdkHelper.zapp_api_path, zapp_request_params(args))

    raise "Failed to create SDK on Zapp with error #{response.status}" unless response.success?

    puts "SDK #{args[:version]} was created!"
  rescue Versionomy::Errors::VersionomyError
    puts "skipping sdk creation, version #{args[:version]} should not be published"
    next
  end
end
