require '/Users/Joe/Documents/Work/joe_utils/lib/joe_utils.rb'

class ProjectUtility

  include CLIHelper
  include RegExpHelper
  include FilesHelper

  HELP_TEXT = 'Project utility:
executes basic administrative tasks with project, so far supported options:
s for skipping tests,
g for pushing to github,
e for pushing to heroku,
b for building a gem, notice, you need to be in the folder which is called as the .gemspec file of the gem,
p for pushing it to rubygems.org,
i for installing it locally,
h for help,
you can combine the options when it makes sense.
Text behind the command will be considered a message for git.'

  def process_input(input, options = {})
    input.each do |arg|
      if arg[0..1] == '--'
        case arg[2..-1]
          when 'build'
            options[:gem_name] ||= get_current_folder
          when 'install'
            options[:install] = true
          when 'push'
            options[:push] = true
          when 'heroku'
            options[:heroku] = true
          when 'github'
            options[:github] = true
          else
            puts HELP_TEXT
            exit
        end
      elsif arg[0] == '-'
        arg[1..-1].each_char do |letter|
          case letter
            when 's'
              options[:skip_tests] = true
            when 'g'
              options[:github] = true
            when 'e'
              options[:heroku] = true
            when 'b'
              options[:gem_name] ||= get_current_folder
            when 'i'
              options[:install] = true
            when 'p'
              options[:push] = true
            else
              puts HELP_TEXT
              exit
          end
        end
      else
        options[:message] = arg
      end
    end
    options
  end

  def run(input = nil)
    options = process_input(input || ARGV)
    rake_test unless options[:skip_tests]
    commit_git(options[:message])
    commit_github if options[:github]
    deploy_heroku if options[:heroku]
    build_gem(options[:gem_name], options) if options[:gem_name]
  end
end