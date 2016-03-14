require 'concourse-fuselage'
require 'contracts'
require_relative 'core'
require_relative 'support/github'
require_relative 'support/params'

module GitHubStatus
  class In < Fuselage::In
    include Core
    include Support::Params
    include Support::GitHub

    Contract HashOf[String, String] => String
    def sha(version)
      @sha ||= version.fetch('context@sha') { commit }.split('@').last
    end

    Contract None => Maybe[String]
    def state
      github
        .statuses(repo, sha)
        .select { |status| status.context == context }
        .map(&:state)
        .first
    end

    Contract None => Num
    def fetch!
      File.write "#{workdir}/#{context}.state", state
    end
  end
end
