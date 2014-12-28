require 'minitest/autorun'
require 'joe_utils/utils/project_utility.rb'

class JoeUtilsTest < Minitest::Test

  def test_commit
    assert(ProjectUtility.new.run(['-s', 'Test proj_util']), 'Commit not successful')
  end

  def test_commit_build
    assert(ProjectUtility.new.run(['-bs', 'Test build proj_util']), 'Build not successful')
  end

  def test_commit_install
    assert(ProjectUtility.new.run(['-is', 'Test build install proj_util']), 'Install not successful')
  end

  def test_commit_push
    assert(ProjectUtility.new.run(['-ps', 'Test build push proj_util']), 'Push not successful')
  end

  # def test_gem_util
  #   assert_equal(true, ProjectUtility.new.run(['ips', 'Test build install push proj_util']))
  # end

  # def test_commit_install_push
  #   ProjectUtility.new.run(['-s', 'Test install push proj_util'])
  # end
end