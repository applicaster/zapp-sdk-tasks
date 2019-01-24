# frozen_string_literal: true

require "spec_helper"

RSpec.describe "S3Helper", type: :rake do

  context "#extract_cdn_uri" do
    
    it "return a correct cdn url" do
        input = "https://s3.amazonaws.com/assets-production.applicaster.com/path/to/file.zip"
        output = "https://assets-production.applicaster.com/path/to/file.zip"
        expect(output).to eq(S3Helper.extract_cdn_uri(input))
    end

  end
end
