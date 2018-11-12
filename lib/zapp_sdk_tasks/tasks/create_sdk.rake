# frozen_string_literal: true

require "faraday"
require "versionomy"
require "logger"
require "git_helper"

desc "Create SDK version on Zapp"
namespace :zapp_sdks do
  task :create, :platform, :version, :project_repo_name, :zapp_token do |_task, args|
    connection = Faraday.new(url: "https://zapp.applicaster.com") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger, ::Logger.new(STDOUT), bodies: true do |logger|
        logger.filter(/(access_token=)(\w+)/, "\1[REMOVED]")
      end

      faraday.adapter Faraday.default_adapter
    end

    version = Versionomy.parse(args[:version])
    release_type = version.release_type

    unless %i[release preview final].include?(release_type)
      puts "skipping sdk creation, version #{args[:version]} should not be published"
      next
    end

    preview = release_type.to_sym == :preview

    unless preview
      base_sdk_id = GitHelper.last_commit_message
                             .match(/\[\s*(?:from\s*[-_])(.+)\s*\]/)
                             .try(:[], 1)
    end

    params = {
      sdk_version: {
        version: args[:version],
        platform: args[:platform],
        screen_sizes: ["universal"],
        status: "stable",
        official: true,
        channel: preview ? "canary_channel" : "stable_channel",
        ci_provider: "circle_ci",
        ci_project_id: args[:project_repo_name],
        base_sdk_version_id: base_sdk_id,
        scm_tag: args[:version],
        build_branch: preview ? args[:version] : "release"
      },
      use_latest_dev: base_sdk_id.to_s.empty?,
      access_token: ENV["ZAPP_TOKEN"] || args[:zapp_token]
    }

    response = connection.post("api/v1/sdk_creation_workers", params)
    raise "Failed to create SDK on Zapp with error #{response.status}" unless response.success?

    puts "SDK #{args[:version]} was created!"
  rescue Versionomy::Errors::VersionomyError
    puts "skipping sdk creation, version #{args[:version]} should not be published"
    next
  end
end
