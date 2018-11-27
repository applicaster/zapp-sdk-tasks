# frozen_string_literal: true

require "versionomy"

class SdkHelper
  def self.zapp_host
    "https://zapp.applicaster.com"
  end

  def self.zapp_api_path
    "api/v1/sdk_creation_workers"
  end

  def self.zapp_request_params(request_options)
    {
      sdk_version: {
        version: request_options[:version],
        platform: request_options[:platform],
        screen_sizes: ["universal"],
        status: "stable",
        official: true,
        channel: preview?(request_options[:version]) ? "canary_channel" : "stable_channel",
        ci_provider: "circle_ci",
        ci_project_id: request_options[:project_repo_name],
        base_sdk_version_id: base_sdk_id(request_options[:version]),
        scm_tag: request_options[:version],
        build_branch: preview?(request_options[:version]) ? request_options[:version] : "release"
      },
      use_latest_dev: base_sdk_id(request_options[:version]).to_s.empty?,
      access_token: ENV["ZAPP_TOKEN"] || request_options[:zapp_token]
    }
  end

  def self.base_sdk_id(version)
    return if preview?(version)

    match_data = GitHelper.last_commit_message.match(/\[\s*(?:from\s*[-_])(.+)\s*\]/)
    return unless match_data

    match_data[1]
  end

  def self.preview?(version)
    release_type(version).to_sym == :preview
  end

  def self.release_type(version)
    version = Versionomy.parse(version)
    version.release_type
  end
end
