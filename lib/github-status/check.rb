require 'concourse-fuselage'
require_relative 'core'
require_relative 'support/github'

module GitHubStatus
  class Check < Fuselage::Check
    include Core
    include Support::GitHub

    Contract HashOf[String, String] => String
    def sha(version)
      @sha ||= version.fetch('context@sha') { commit }.split('@').last
    end

    Contract String => Time
    def date(sha)
      @date ||= github.commit(repo, sha).commit.author.date
    end

    Contract None => String
    def commit
      @commit ||= github.branch(repo, branch).commit.sha
    end

    Contract None => HashOf[String, String]
    def latest
      { 'context@sha' => "concourseci@#{commit}" }
    end

    Contract HashOf[String, String] => ArrayOf[HashOf[String, String]]
    def since(version)
      github
        .commits_since(repo, date(sha(version)))
        .map { |commit| { 'context@sha' => "concourseci@#{commit[:sha]}" } }
    end
  end
end
