Gem::Specification.new do |s|
  s.name = 'joe_utils'
  s.version = '0.0.4'
  s.executables = %w(gem_util.sh)

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Josef Erneker']
  s.date = %q{2014-12-26}
  s.description = %q{Overall personal utils gem}
  s.licenses = ['GPL-3.0']
  s.email = %q{josef.erneker@gmail.com}
  s.files = `git ls-files`.split($\)
  s.test_files = s.files.grep(/^test_/)
  s.homepage = %q{http://rubygems.org/gems/joeutils}
  s.require_paths = ['lib']
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Utils for work with files, sockets etc.}
  s.add_development_dependency %w(minitest), '~> 0'
end

