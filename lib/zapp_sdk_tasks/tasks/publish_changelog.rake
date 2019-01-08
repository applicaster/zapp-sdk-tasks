# frozen_string_literal: true

require "aws-sdk-s3"
require "versionomy"
require "zapp_sdk_tasks/s3_helper"
require "zapp_sdk_tasks/changelog_helper"

desc "Generate Changelog.md and publish to s3"
namespace :zapp_sdks do
  task :publish_changelog, :platform, :version do |_task, args|
    begin
      if SdkHelper.triggered_by_zapp?
        puts "skipping sdk creation, was triggered by Zapp CMS"
        next
      end

      version = Versionomy.parse(args[:version])
      release_type = version.release_type

      unless %i[release preview final].include?(release_type)
        puts "skipping changelog publish, version #{args[:version]} should not be published"
        next
      end

      ChangelogHelper.generate_changelog(args[:platform], args[:version])
      s3 = S3Helper.resource_from_env_vars

      obj = s3.bucket(ENV["S3_BUCKET_NAME"])
              .object("zapp/sdk_versions/#{args[:platform]}/#{args[:version]}/CHANGELOG.md")

      File.open("CHANGELOG.md", "rb") do |file|
        obj.put({ body: file }.merge(S3Helper.write_options))
      end

      ChangelogHelper.print_success(args[:platform], args[:version])
    rescue Versionomy::Errors::VersionomyError
      puts "skipping changelog publish, version #{args[:version]} should not be published"
      next
    end
  end
end
