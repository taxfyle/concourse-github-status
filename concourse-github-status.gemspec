Gem::Specification.new do |gem|
  gem.name          = 'concourse-github-status'
  gem.version       = '0.2.2'
  gem.license       = 'Apache-2.0'
  gem.summary       = 'GitHub Status resource for Concourse'

  gem.author        = 'Chris Olstrom'
  gem.email         = 'chris@olstrom.com'
  gem.homepage      = 'https://github.com/colstrom/concourse-github-status'

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'concourse-fuselage', '~> 0.1', '>= 0.1.0'
  gem.add_runtime_dependency 'git', '~> 1.3', '>= 1.3.0'
  gem.add_runtime_dependency 'octokit', '~> 4.2', '>= 4.2.0'
end
