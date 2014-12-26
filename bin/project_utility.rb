#!/usr/bin/env ruby

require 'joe_utils'

class ProjectUtility

  include CLIHelper
  include RegExpHelper

  HELP_TEXT = 'Provide me with the name of the gem, you also can add options:
  i for installing the gem locally, p for pushing the gem to rubygems.org, h for help.',
  INCLUDE_GEM_NAME = 'You did not enter a gem name.
  Please include it as an argument to the script or hard code it as a variable in the script.',

  def process_input(input, options = {})
    message = nil
    input.each do |arg|
      if message
        options[:message] = arg
        next
      end
      case arg
        when '-g', '--github'
          options[:github] = true
        when '-h', '--heroku'
          options[:heroku] = true
        when '-gh'
          options[:github] = options[:heroku] = true
        when '-i', '--install'
          options[:install] = true
        when '-p', '--push'
          options[:push] = true
        when '-h', '--help'
          puts HELP_TEXT
          exit
        when '-ip'
          options[:install] = options[:push] = true
        when '-m'
          message = true
        else
          options[:gem_name] = arg
      end
    end
    options
  end

  def run
    options = process_input(ARGV)
    commit_git(options[:message])
    commit_github if options[:github]
    deploy_heroku if options[:heroku]
    build_gem(options[:gem_name], options) if options[:gem_name]
  end
end

ProjectUtility.new.run