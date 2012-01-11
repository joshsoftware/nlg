# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nlg/version"

Gem::Specification.new do |s|
  s.name        = "nlg"
  s.version     = Nlg::VERSION
  s.authors     = ["Sricharan Sunder", "Jiren Patel", "Gautam Rege"]
  s.email       = ["sricharan@joshsoftware.com", "jiren@joshsoftware.com", "gautam@joshsoftware.com"]
  s.homepage    = "http://github.com/joshsoftware/nlg"
  s.summary     = %q{Natural Language Generation in Ruby}
  s.description = %q{Build articles and paragraphs from structured data. Instead of a standard template, we can use this to build articles that are grammatically correct and creative.}

  s.rubyforge_project = "nlg"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "verbs" 
  s.add_dependency "active_support" 
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
