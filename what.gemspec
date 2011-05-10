# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "what/version"

Gem::Specification.new do |s|
  s.name        = "what"
  s.version     = What::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Lower", "Ryan Fitzgerald"]
  s.email       = ["team@academia.edu"]
  s.homepage    = "http://academia.edu/"
  s.summary     = %q{Simple server monitoring tool}
  s.description = "What uses WEBrick to serve a JSON object representing the" +
                  "state of services running on a machine. It currently only" +
                  "includes a module for monitoring Unicorn workers, but" +
                  "it's easy to add custom modules."

  s.rubyforge_project = "what"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("rack", ">= 1.1.2")
  s.add_dependency("json")
end
