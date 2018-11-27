# frozen_string_literal: true

require "spec_helper"

RSpec.describe "zapp_sdks:publish_changelog", type: :rake do
  let(:bucket)      { double("Bucket") }
  let(:s3_object)   { double("S3Object") }

  before do
    Rake::Task["zapp_sdks:publish_changelog"].reenable
    allow_any_instance_of(Kernel).to receive(:system)

    allow_any_instance_of(Kernel).to receive(:system)
      .with("npm i changelog-maker -g")

    ENV["AWS_ACCESS_KEY_ID"] = "access_key_id"
    ENV["AWS_SECRET_ACCESS_KEY"] = "secret_access_key"
    ENV["AWS_REGION"] = "region"

    allow_any_instance_of(Aws::S3::Resource).to receive(:bucket).and_return bucket

    allow(bucket).to receive(:object)
      .with("zapp/sdk_versions/android/1.0-preview1/CHANGELOG.md")
      .and_return s3_object
  end

  it "has the correct name" do
    expect(subject.name).to eq("zapp_sdks:publish_changelog")
  end

  context "when it's development version" do
    it "skips publishing" do
      expect(s3_object).not_to receive(:put)
      Rake::Task["zapp_sdks:publish_changelog"].invoke("android", "1.0b1")
    end
  end

  context "when it's a preview version" do
    it "call changelog generator" do
      allow(s3_object).to receive(:put).and_return true

      expect_any_instance_of(Kernel).to receive(:system)
        .with("./node_modules/.bin/changelog-maker --all >> CHANGELOG.md")

      Rake::Task["zapp_sdks:publish_changelog"].invoke("android", "1.0-preview1")
    end

    it "publish the changelog to s3" do
      expect(s3_object).to receive(:put)
      Rake::Task["zapp_sdks:publish_changelog"].invoke("android", "1.0-preview1")
    end
  end
end
