require 'contracts'

module GitHubStatus
  module Support
    module Params
      include ::Contracts::Core
      include ::Contracts::Builtin
    end
  end
end
