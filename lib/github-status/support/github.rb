require 'contracts'
require 'octokit'

module GitHubStatus
  module Support
    module GitHub
      include ::Contracts::Core
      include ::Contracts::Builtin
      include Source

      Contract None => Octokit::Client
      def github
        @github ||= Octokit::Client.new access_token: access_token
      end
    end
  end
end
