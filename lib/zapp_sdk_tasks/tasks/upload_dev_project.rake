# frozen_string_literal: true

require "aws-sdk-s3"
require "faraday"
require "logger"

desc "Upload development project to S3, and update Zapp with the link"
namespace :zapp_sdks do
  task :upload_dev_project, :project_path do |_task, args|
    begin
      s3 = S3Helper.resource_from_env_vars

      obj = s3.bucket(ENV["S3_BUCKET_NAME"])
              .object(
                "zapp/" \
                "accounts/#{ENV['accounts_account_id']}/" \
                "apps/#{ENV['bundle_identifier']}/" \
                "#{ENV['store']}/" \
                "#{ENV['version_name']}/" \
                "dev_project/dev_project.zip"
              )

      File.open(args[:project_path], "rb") do |file|
        obj.put({ body: file }.merge(S3Helper.write_options))
      end

      puts "succefully uploaded the dev project to s3"
      Rake::Task["zapp_sdks:update_zapp_version"].invoke(S3Helper.extract_cdn_uri(obj.public_url))
    end
  end
end

desc "update zapp with the project link"
namespace :zapp_sdks do
  task :update_zapp_version, :project_link do |_task, args|
    begin
      unless args[:project_link]
        puts "skipping zapp app version update. Empty dev project link"
        next
      end

      connection = Faraday.new(url: SdkHelper.zapp_host) do |faraday|
        faraday.request  :url_encoded

        faraday.response :logger, ::Logger.new(STDOUT), bodies: true do |logger|
          logger.filter(/(access_token=)(\w+)/, "\1[REMOVED]")
        end

        faraday.adapter Faraday.default_adapter
      end

      params = {
        app_version: { source_code_download_link: args[:project_link] },
        access_token: ENV["ZAPP_TOKEN"]
      }

      response = connection.put("api/v1/app_versions/#{ENV['version_id']}", params)
      raise "Failed to update version on Zapp. Error: #{response.status}" unless response.success?

      puts "Version with id #{ENV['version_id']} was updated!"

      puts "development project was updated!"
    end
  end
end
