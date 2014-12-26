module CLIHelper

  MESSAGES = {
      commit_git: 'Commiting to git...',
      push_rubygems: 'Pushing to rubygems.org...',
      install_gem: 'Installing gem and jgem locally...',
      build_gem: 'Building gem...',
      build_gem_failed: 'The gem build failed. Please confirm the gem name and try again.',
      deploy_heroku: 'Deploying to heroku.',
      commit_github: 'Commiting to github.',
      default_message: 'Commit by script'
  }

  def get_current_address
    `PWD`
  end

  def get_current_folder
    `basename $PWD`
  end

  # Commits to git
  # @return [nil]
  def commit_git(message)
    puts MESSAGES[:commit_git]
    puts `git add -u`
    puts `git commit -m "#{message || MESSAGES[:default_message]}"`
  end

  # Builds the named gem locally, in case of provided options pushes and installs the gem
  # @param [String] gem_name
  # @param [Hash] options, supported options: :push for pushing to rubygems.org, :install for installing the gem locally
  # @return [nil]
  def build_gem(gem_name, options = {})
    puts MESSAGES[:build_gem]
    puts(gem_built_name = `gem build "#{gem_name}.gemspec"`)
    gem_built_name = gem_built_name.match(/File: /).post_match
    if gem_built_name && !gem_built_name.empty?
      push_rubygems(gem_built_name) if options[:push]
      install_gem(gem_built_name) if options[:install]
    else
      puts MESSAGES[:build_gem_failed]
    end
  end

  # Pushes the named gem to rubygems.org
  # @param [String] gem_built_name
  # @return [nil]
  def push_rubygems(gem_built_name)
    puts MESSAGES[:push_rubygems]
    puts `gem push #{gem_built_name}`
  end

  # Installs the named gem locally
  # @param [String] gem_built_name
  # @return [nil]
  def install_gem(gem_built_name)
    puts MESSAGES[:install_gem]
    puts `gem install #{gem_built_name}`
    puts `jgem install #{gem_built_name}`
  end

  # @return [nil]
  def commit_github
    puts MESSAGES[:commit_github]
    puts `git push origin master`
  end

  # @return [nil]
  def deploy_heroku
    puts MESSAGES[:deploy_heroku]
    puts `git push heroku master`
  end
end