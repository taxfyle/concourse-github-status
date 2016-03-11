#!/usr/bin/env ruby

require 'concourse-fuselage'
require 'contracts'
require 'git'
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

    Contract None => Sawyer::Resource
    def update!
      github.create_status repo, sha, state, options
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
