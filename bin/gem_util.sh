#!/bin/sh

# Create a Ruby gem and push it to rubygems.org and update it locally

GEMSPEC_SUFFIX=".gemspec"

function usage
{
    echo "usage: system_page [[[-p push] [-i install]] | [-h]]"
}

# checking options of the script and name of the gem to work with
while [ "$1" != "" ]; do
    case $1 in
        -i | --install )        INSTALL=1
                                ;;
        -p | --push )           PUSH=1
                                ;;
        -h | --help )           usage
                                ;;
        -ip )                   INSTALL=1
                                PUSH=1
                                ;;
        * )                     GEM_NAME=$1
    esac
    shift
done

# if the gem name has not been defined, print error message and exit
if [ -z "$GEM_NAME" ]; then
    echo "You did not enter a gem name.  Please include it as an argument to the script or hard code it as a variable in the script." >&2
    exit 1
fi

# run the gem build and parse for the gem release filename
GEM_BUILD_NAME=$(gem build "$GEM_NAME$GEMSPEC_SUFFIX" |  awk '/File/ {print $2}' -)

# if the build failed (i.e. no file name obtained above), print error message and exit
if [ -z "$GEM_BUILD_NAME" ]; then
    echo "The gem build failed. Please confirm the gem name and try again." >&2
    exit 1
else
    echo "Built successful"
fi

# if above succeeded, then push to rubygems.org using the gem that was compiled
if [ "$PUSH" ]; then
    echo "Pushing..."
    gem push "$GEM_BUILD_NAME"
fi

# install it locally
if [ "$INSTALL" ]; then
    echo "Installing..."
    gem install "$GEM_BUILD_NAME"
    jgem install "$GEM_BUILD_NAME"
fi

exit 0
