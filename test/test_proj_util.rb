require 'minitest/autorun'
require 'joe_utils/utils/project_utility.rb'

class JoeUtilsTest < Minitest::Test

  def test_commit
    ProjectUtility.new.run(['-s', 'Test proj_util'])
  end

  def test_commit_build
    ProjectUtility.new.run(['-bs', 'Test build proj_util'])
  end

  def test_commit_install
    ProjectUtility.new.run(['-is', 'Test build install proj_util'])
  end

  def test_commit_push
    ProjectUtility.new.run(['-ps', 'Test build push proj_util'])
  end

  def test_gem_util
    ProjectUtility.new.run(['ips', 'Test build install push proj_util'])
  end

  # def test_commit_install_push
  #   ProjectUtility.new.run(['-s', 'Test install push proj_util'])
  # end
end