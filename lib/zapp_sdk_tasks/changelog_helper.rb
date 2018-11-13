# frozen_string_literal: true

class ChangelogHelper
  def self.generate_changelog(platform, version)
    install_changelog_maker
    init_changelog(platform, version)
    system "./node_modules/.bin/changelog-maker --all >> CHANGELOG.md"
  end

  def self.install_changelog_maker
    system "npm i changelog-maker"
  end

  def self.init_changelog(platform, version)
    File.open("CHANGELOG.md", "w+") do |f|
      f.write("##{platform} SDK Version: #{version}\n\n")
    end
  end

  def self.print_success(platform, version)
    <<~HEREDOC
      Changelog uploaded!
      https://assets-production.applicaster.com/zapp/sdk_versions/#{platform}/#{version}/CHANGELOG.md"
    HEREDOC
  end
end
