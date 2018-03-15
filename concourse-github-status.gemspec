Gem::Specification.new do |gem|
  tag = `git describe --tags --abbrev=0`.chomp

  gem.name          = 'concourse-github-status'
  gem.homepage      = 'https://github.com/colstrom/concourse-github-status'
  gem.summary       = 'GitHub Status resource for Concourse'

  gem.version       = "#{tag}"
  gem.licenses      = ['MIT']
  gem.authors       = ['Chris Olstrom']
  gem.email         = 'chris@olstrom.com'

  gem.cert_chain    = ['trust/certificates/colstrom.pem']
  gem.signing_key   = File.expand_path ENV.fetch 'GEM_SIGNING_KEY'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = `git ls-files -z -- bin/*`.split("\x0").map { |f| File.basename(f) }
  gem.test_files    = `git ls-files -z -- {test,spec,features}/*`.split("\x0")

  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'concourse-fuselage', '~> 0.1', '>= 0.1.0'
  gem.add_runtime_dependency 'git',                '~> 1.3', '>= 1.3.0'
  gem.add_runtime_dependency 'octokit',            '~> 4.2', '>= 4.2.0'
end
