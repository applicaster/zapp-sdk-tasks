# frozen_string_literal: true

require "spec_helper"

RSpec.describe "zapp_sdks:create", type: :rake do
  let(:connection) { double("connection") }

  before do
    Rake::Task["zapp_sdks:create"].reenable
    ENV["ZAPP_TOKEN"] = "1234"

    allow(Faraday).to receive(:new)
      .with(url: "https://zapp.applicaster.com")
      .and_return(connection)
  end

  it "has the correct name" do
    expect(subject.name).to eq("zapp_sdks:create")
  end

  context "when it's development version" do
    it "skip creation" do
      expect(connection).not_to receive(:post)
      Rake::Task["zapp_sdks:create"].invoke("android", "1.0b1", "zapp-android")
    end
  end

  context "when it's preview version" do
    let(:response) { double("response", success?: true) }

    it "create a canary channel version" do
      expect(connection).to receive(:post)
        .with("api/v1/sdk_creation_workers", request_params)
        .and_return(response)

      Rake::Task["zapp_sdks:create"].invoke("android", "1.0-preview1", "zapp-android")
    end

    def request_params
      {
        sdk_version: {
          version: "1.0-preview1",
          platform: "android",
          screen_sizes: ["universal"],
          status: "stable",
          official: true,
          channel: "canary_channel",
          ci_provider: "circle_ci",
          ci_project_id: "zapp-android",
          base_sdk_version_id: nil,
          scm_tag: "1.0-preview1",
          build_branch: "1.0-preview1"
        },
        use_latest_dev: true,
        base_sdk_version_id: nil,
        access_token: "1234"
      }
    end
  end

  context "latest commit has a 'from' message" do
    let(:response) { double("response", success?: true) }

    before do
      allow(GitHelper).to receive(:last_commit_message).and_return("commit message [from-12345]")
    end

    it "send request with the correct param" do
      expect(connection).to receive(:post)
        .with("api/v1/sdk_creation_workers", request_params)
        .and_return(response)

      Rake::Task["zapp_sdks:create"].invoke("android", "1.0", "zapp-android")
    end

    def request_params
      {
        sdk_version: {
          version: "1.0",
          platform: "android",
          screen_sizes: ["universal"],
          status: "stable",
          official: true,
          channel: "stable_channel",
          ci_provider: "circle_ci",
          ci_project_id: "zapp-android",
          base_sdk_version_id: "12345",
          scm_tag: "1.0",
          build_branch: "release"
        },
        use_latest_dev: false,
        base_sdk_version_id: "12345",
        access_token: "1234"
      }
    end
  end

  context "latest commit does not have a 'from' message" do
    let(:response) { double("response", success?: true) }

    before do
      allow(GitHelper).to receive(:last_commit_message).and_return("commit message")
    end

    it "send request with the correct params" do
      expect(connection).to receive(:post)
        .with("api/v1/sdk_creation_workers", request_params)
        .and_return(response)

      Rake::Task["zapp_sdks:create"].invoke("android", "1.0", "zapp-android")
    end

    def request_params
      {
        sdk_version: {
          version: "1.0",
          platform: "android",
          screen_sizes: ["universal"],
          status: "stable",
          official: true,
          channel: "stable_channel",
          ci_provider: "circle_ci",
          ci_project_id: "zapp-android",
          base_sdk_version_id: nil,
          scm_tag: "1.0",
          build_branch: "release"
        },
        use_latest_dev: true,
        base_sdk_version_id: nil,
        access_token: "1234"
      }
    end
  end

  context "when request fails" do
    let(:response) { double("response", success?: false, status: 500) }

    before do
      allow(connection).to receive(:post).and_return(response)
    end

    it "throws error exit 1" do
      expect_any_instance_of(Kernel).to receive(:raise)
      Rake::Task["zapp_sdks:create"].invoke("android", "1.0", "zapp-android")
    end
  end
end
