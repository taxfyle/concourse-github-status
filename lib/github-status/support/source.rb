require 'contracts'

module GitHubStatus
  module Support
    module Source
      include ::Contracts::Core
      include ::Contracts::Builtin

      Contract None => String
      def access_token
        @access_token ||= source.fetch 'access_token'
      rescue KeyError
        STDERR.puts 'Source is missing access_token'
        abort
      end

      Contract None => String
      def repo
        @repo ||= source.fetch 'repo'
      rescue KeyError
        STDERR.puts 'Source is missing repo'
        abort
      end
    end
  end
end
