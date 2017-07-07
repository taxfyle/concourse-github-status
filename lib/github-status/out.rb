#!/usr/bin/env ruby

require 'concourse-fuselage'
require 'contracts'
require_relative 'core'
require_relative 'support/params'
require_relative 'support/git'
require_relative 'support/github'

module GitHubStatus
  class Out < Fuselage::Out
    include Core
    include Support::Params
    include Support::Git
    include Support::GitHub

    Contract None => Or[Sawyer::Resource, ArrayOf[Sawyer::Resource]]
    def update!
      if statuses.empty?
        github.create_status repo, sha, state, options
      else
        statuses.map do |status|
          options = {
            context: status["context"],
            target_url: target_url,
            description: status["description"]
          }
          github.create_status repo, sha, status["state"], options
        end
      end
    rescue Octokit::Error => error
      STDERR.puts error.message
      abort
    end

    Contract None => HashOf[String, String]
    def version
      { 'context@sha' => "#{context}@#{sha}" }
    end

    Contract None => String
    def target_url
      @target_url ||= "#{atc_external_url}/builds/#{build_id}"
    end

    Contract None => HashOf[Symbol, String]
    def options
      @options ||= {
        context: context,
        target_url: target_url,
        description: description
      }
    end
  end
end
