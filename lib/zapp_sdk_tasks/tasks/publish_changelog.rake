require "aws-sdk-s3"
require "versionomy"
require "pry"

desc "Generate Changelog.md and publish to s3"
namespace :zapp_sdks do
  task :publish_changelog, :platform, :version do |_task, args|
    begin
      version = Versionomy.parse(args[:version])
      release_type = version.release_type

      unless %i(release preview final).include?(release_type)
        puts "skipping changelog publish, version #{args[:version]} should not be published"
        next
      end

      system "npm i changelog-maker"

      File.open("CHANGELOG.md", "w+") do |f|
        f.write("##{args[:platform]} SDK Version: #{args[:version]}\n\n")
      end

      system "./node_modules/.bin/changelog-maker --all >> CHANGELOG.md"

      s3 = Aws::S3::Resource.new(
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        region: ENV["AWS_REGION"],
      )

      write_options = { acl: "public-read", cache_control: "max-age=60" }

      obj = s3.bucket(ENV["S3_BUCKET_NAME"])
              .object("zapp/sdk_versions/#{args[:platform]}/#{args[:version]}/CHANGELOG.md")

      File.open("CHANGELOG.md", "rb") do |file|
        obj.put({ body: file }.merge(write_options))
      end

      puts "Changelog uploaded!"

      puts "https://assets-secure.applicaster.com/zapp/sdk_versions/"\
        "#{args[:platform]}/#{args[:version]}/CHANGELOG.md"

    rescue Versionomy::Errors::VersionomyError
      puts "skipping changelog publish, version #{args[:version]} should not be published"
      next
    end
  end
end
