require 'gemsurance/runner'

desc 'Discover which bundled gems need to be updated due to vulnerabilities'
task :gemsurance do
  Gemsurance::Runner.run
end