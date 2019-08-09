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

      Contract None => Enum['success', 'pending', 'failure']
      def state
        @state ||= params.fetch 'state'
      rescue KeyError
        STDERR.puts 'Params is missing state'
        abort
      end

      Contract None => String
      def context
        @context ||= params.fetch 'context', ENV["BUILD_JOB_NAME"]
      end

      Contract None => String
      def description
        @description ||= params.fetch 'description', "#{ENV["BUILD_JOB_NAME"]} number #{ENV["BUILD_NAME"]}"
      end

      Contract None => Array
      def statuses
        @statuses ||= params.fetch 'statuses', []
      end

      Contract None => String
      def target_url
        url = params.fetch 'target_url', "#{atc_external_url}/builds/#{build_id}"
        if File.file?("#{workdir}/#{url}")
          url = File.read("#{workdir}/#{url}").chomp
        end
        @target_url ||= url
      end
    end
  end
end
