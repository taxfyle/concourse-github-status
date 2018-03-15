module GitHubStatus
  VERSION = $LOADED_FEATURES
              .map { |f| f.match %r{/concourse-github-status-(?<version>[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+(\.pre)?)} }
              .compact
              .map { |gem| gem['version'] }
              .uniq
              .first
end
