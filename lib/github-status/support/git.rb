require 'contracts'
require 'git'

module GitHubStatus
  module Support
    module Git
      include ::Contracts::Core
      include ::Contracts::Builtin

      Contract None => ::Git::Base
      def git
        @git ||= ::Git.open "#{workdir}/#{path}"
      rescue ArgumentError
        STDERR.puts "#{path} is not a git repository"
        abort
      end

      Contract None => String
      def sha
        @sha ||= if File.file? "#{workdir}/#{path}"
          File.read("#{workdir}/#{path}").chomp
        else
          git.revparse 'HEAD'
        end
      end
    end
  end
end
