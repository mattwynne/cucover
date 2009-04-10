# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cucover"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.author = "Matt Wynne"
  s.date = '2009-03-18'
  s.description = s.summary = 'Cucover is a thin wrapper for Cucumber which makes it lazy.'
  s.email = 'matt@mattwynne.net'
  s.files = ["lib/cucover.rb", "bin/cucover", "README.markdown"]
  s.has_rdoc = false
  s.homepage = 'http://github.com/mattwynne/cucover'
  s.require_paths = ["lib", "bin"]
  s.rubyforge_project = 'cucover'
  s.rubygems_version  = '1.3.1'

  # s.add_dependency 'cucumber', '>= 0.2'
  # s.add_dependency 'rcov',     '>= 0.8.1.5'
end
