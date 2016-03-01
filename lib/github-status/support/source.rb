require 'contracts'

module GitHubStatus
  module Support
    module Source
      include ::Contracts::Core
      include ::Contracts::Builtin

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
