# frozen_string_literal: true

require "uri"

class S3Helper
  def self.resource_from_env_vars
    Aws::S3::Resource.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"]
    )
  end

  def self.write_options
    { acl: "public-read", cache_control: "max-age=60" }
  end

  def self.extract_cdn_uri(uri)
    cdn_uri = URI(uri)
    cdn_uri.host = nil
    cdn_uri.path = "/" + cdn_uri.path
    cdn_uri.to_s
  end
end
