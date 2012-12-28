# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'combustion'
  s.version     = '0.3.3'
  s.authors     = ['Pat Allan']
  s.email       = ['pat@freelancing-gods.com']
  s.homepage    = ''
  s.summary     = 'Elegant Rails Engine Testing'
  s.description = 'Test your Rails Engines without needing a full Rails app'

  s.rubyforge_project = 'combustion'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'activesupport', '>= 3.0.0'
  s.add_runtime_dependency 'thor',  '>= 0.14.6'
end
