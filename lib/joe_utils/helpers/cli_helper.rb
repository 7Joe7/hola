module CLIHelper

  MESSAGES = {
      add_git: 'Adding to git...',
      commit_git: 'Commiting to git...',
      push_rubygems: 'Pushing to rubygems.org...',
      install_gem: 'Installing gem and jgem locally...',
      build_gem: 'Building gem...',
      build_gem_failed: 'The gem build failed. Please confirm the gem name and try again.',
      deploy_heroku: 'Deploying to heroku.',
      commit_github: 'Commiting to github.',
      commit_default_message: 'Commit by script',
      rake_test: 'Running tests...',
  }

  # Commits to git
  # @return [Boolean]
  def commit_git(message)
      execute(:add_git, 'git add -u') &&
          execute(:commit_git, "git commit -m \"#{message || MESSAGES[:commit_default_message]}\"")
  end

  # Builds the named gem locally, in case of provided options pushes and installs the gem
  # @param [String] gem_name
  # @param [Hash] options, supported options: :push for pushing to rubygems.org, :install for installing the gem locally
  # @return [Boolean]
  def build_gem(gem_name, options = {})
    puts MESSAGES[:build_gem]
    success = true
    puts(gem_built_name = `gem build "#{gem_name}.gemspec"`)
    gem_built_name = gem_built_name.match(/File: /).post_match
    if gem_built_name && !gem_built_name.empty?
      success = push_rubygems(gem_built_name) if options[:push]
      options[:install] ? install_gem(gem_built_name) && install_jgem(gem_built_name) && success : success
    else
      puts MESSAGES[:build_gem_failed]
    end
  end

  # Pushes the named gem to rubygems.org
  # @param [String] gem_built_name
  # @return [Boolean]
  def push_rubygems(gem_built_name)
    execute(:push_rubygems, "gem push #{gem_built_name}")
  end

  # Installs the named gem locally
  # @param [String] gem_built_name
  # @return [Boolean]
  def install_gem(gem_built_name)
    execute(:install_gem, "gem install #{gem_built_name}")
  end

  # Installs the named jgem locally
  # @param [String] gem_built_name
  # @return [Boolean]
  def install_jgem(gem_built_name)
    execute(:install_jgem, "jgem install #{gem_built_name}")
  end

  # @return [Boolean]
  def commit_github
    execute(:commit_github, 'git push origin master')
  end

  # @return [Boolean]
  def deploy_heroku
    execute(:deploy_heroku, 'git push heroku master')
  end

  # @return [Boolean]
  def rake_test
    execute(:rake_test, 'rake test')
  end

  # @param [Symbol] message_key
  # @param [String] command
  # @return [Boolean]
  def execute(message_key, command, no_success_pattern = nil)
    puts MESSAGES[message_key] if message_key
    puts (result = `#{command}`)
    result !~ no_success_pattern || RegExpHelper::NO_SUCCESS
  end
end