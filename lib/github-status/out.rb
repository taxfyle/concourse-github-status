#!/usr/bin/env ruby

require 'concourse-fuselage'
require 'contracts'
require 'git'
require 'octokit'
require_relative 'core'
require_relative 'support/params'

module GitHubStatus
  class Out < Fuselage::Out
    include Core
    include Support::Params

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

    Contract None => Git::Base
    def git
      @git ||= Git.open "#{workdir}/#{path}"
    rescue ArgumentError
      STDERR.puts "#{path} is not a git repository"
      abort
    end

    Contract None => String
    def sha
      @sha ||= git.revparse 'HEAD'
    end

    Contract None => Octokit::Client
    def github
      @github ||= Octokit::Client.new access_token: access_token
    end
  end
end
