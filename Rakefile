require 'rubygems'
require 'bundler'
require 'rake'

require 'rake/testtask'

Bundler::GemHelper.install_tasks

namespace :test do
  Rake::TestTask.new(:units) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
end

desc 'Default: run the unit tests'
task :default => 'test:units'