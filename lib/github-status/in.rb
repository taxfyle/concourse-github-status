require 'concourse-fuselage'
require 'contracts'
require_relative 'core'
require_relative 'support/git'
require_relative 'support/github'
require_relative 'support/params'

module GitHubStatus
  class In < Fuselage::In
    include Core
    include Support::Params
    include Support::Git
    include Support::GitHub

    Contract None => Maybe[String]
    def state
      github
        .statuses(repo, sha)
        .select { |status| status.context == context }
        .map(&:state)
        .first
    end

    def fetch!
      File.write "#{workdir}/#{context}.state", state
    end
  end
end
