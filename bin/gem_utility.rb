#!/usr/bin/env ruby

HELP_TEXT = 'Provide me with the name of the gem, you also can add options:
i for installing the gem locally, p for pushing the gem to rubygems.org, h for help.'

def print_help
  puts HELP_TEXT
end

gem_name = install = push = nil

ARGV.each do |arg|
  case arg
    when '-i', '--install'
      install = true
    when '-p', '--push'
      push = true
    when '-h', '--help'
      print_help
    when '-ip'
      install = true
      push = true
    else
      gem_name = arg
  end
end

puts 'Commiting...'

`git add -u`
`git commit -m "Build gem version"`

puts 'Building...'

# if the gem name has not been defined, print error message and exit
if gem_name
  # run the gem build and parse for the gem release filename
  puts `(gem build #{gem_name}.gemspec | awk '/File/ {print $2})`
  puts $2
  puts `awk '/File/ {print $2}`

  # if the build failed (i.e. no file name obtained above), print error message and exit
  if gem_build_name
    puts 'Built successful'
    # if above succeeded, then push to rubygems.org using the gem that was compiled
    if push
      puts 'Pushing...'
      `gem push #{gem_build_name}`
    end
    # install it locally
    if install
      puts 'Installing...'
      `gem install #{gem_build_name}`
      `jgem install #{gem_build_name}`
    end
  else
    puts 'The gem build failed. Please confirm the gem name and try again.'
  end
else
  puts 'You did not enter a gem name.
Please include it as an argument to the script or hard code it as a variable in the script.'
end