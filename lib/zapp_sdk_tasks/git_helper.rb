# frozen_string_literal: true

class GitHelper
  def self.last_commit_message
    `git log -1 --oneline`
  end
end
