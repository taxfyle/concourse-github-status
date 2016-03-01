require 'contracts'

module GitHubStatus
  module Support
    module Params
      include ::Contracts::Core
      include ::Contracts::Builtin

      Contract None => String
      def path
        @path ||= params.fetch 'path'
      rescue KeyError
        STDERR.puts 'Params is missing path'
        abort
      end

      Contract None => String
      def state
        @state ||= params.fetch 'state'
      rescue KeyError
        STDERR.puts 'Params is missing state'
        abort
      end

      Contract None => String
      def context
        @context ||= params.fetch 'context', 'concourse'
      end
    end
  end
end
