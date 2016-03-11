require 'contracts'
require 'git'

module GitHubStatus
  module Support
    module Git
      include ::Contracts::Core
      include ::Contracts::Builtin
    end
  end
end
