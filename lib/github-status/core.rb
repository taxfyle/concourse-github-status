require 'contracts'
require_relative 'support/source'

module GitHubStatus
  module Core
    include ::Contracts::Core
    include ::Contracts::Builtin
    include ::Support::Source
  end
end
