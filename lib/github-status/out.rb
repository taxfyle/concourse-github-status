#!/usr/bin/env ruby

require 'concourse-fuselage'
require 'contracts'
require 'git'
require 'octokit'

module GitHubStatus
  class Out < Fuselage::Out
    Contract None => String
    def repo
      @repo ||= source.fetch 'repo'
    rescue KeyError
      STDERR.puts 'Source is missing repo'
      abort
    end

    Contract None => String
    def github_access_token
      @github_access_token ||= source.fetch 'github_access_token'
    rescue KeyError
      STDERR.puts 'Source is missing github_access_token'
      abort
    end

    Contract None => String
    def state
      @state ||= params.fetch 'state'
    rescue KeyError
      STDERR.puts 'Params is missing state'
      abort
    end

    Contract None => String
    def path
      @path ||= params.fetch 'path'
    rescue KeyError
      STDERR.puts 'Params is missing path'
      abort
    end

    Contract None => String
    def context
      @context ||= params.fetch 'context', 'concourse'
    end

    Contract None => String
    def description
      @description ||= params.fetch 'description', ''
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

    Contract None => Git::Repository
    def git
      @git ||= Git.open "#{working_path}/#{path}"
    rescue ArgumentError
      STDERR.puts "#{path} is not a git repository"
      abort
    end

    Contract None => String
    def sha
      @repo ||= git.revparse 'HEAD'
    end

    Contract None => HashOf[String, String]
    def version
      { 'context@sha' => "#{context}@#{sha}" }
    end

    Contract None => Octokit::Client
    def github
      @github ||= Octokit::Client.new access_token: github_access_token
    end

    Contract None => Sawyer::Resource
    def update!
      github.create_status repo, sha, state, options
    rescue Octokit::Error => error
      STDERR.puts error.message
      abort
    end
  end
end
