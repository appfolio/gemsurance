$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'gemsurance/version'

Gem::Specification.new do |s|
  s.name                      = "gemsurance"
  s.version                   = Gemsurance::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors                   = ["Jon Kessler"]
  s.date                      = "2013-03-14"
  s.description               = "Gem vulnerability and version checker"
  s.email                     = "jon.kessler@appfolio.com"

  s.homepage                  = "http://github.com/appfolio/gemsurance"
  s.licenses                  = ["MIT"]
  s.require_paths             = ["lib"]
  s.rubygems_version          = "1.8.24"
  s.summary                   = "Your Gem Insurance Policy"
  
  s.files                     = `git ls-files -- bin lib`.split("\n")
  s.executables               = ["gemsurance"]

  s.add_dependency("bundler", "~> 1.2")
  
  s.add_development_dependency("mocha", "0.9.8")
  s.add_development_dependency("rake", "0.9.2.2")
end