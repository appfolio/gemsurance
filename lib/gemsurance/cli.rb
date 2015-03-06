require 'optparse'

module Gemsurance
  class Cli
    class << self
      def parse(*argv)

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Usage: gemsurance [options]"

          opts.separator ""
          opts.separator "Options:"

          opts.on("--pre", "Consider pre-release gem versions") do |lib|
            options[:pre] = true
          end

          opts.on("--output FILE", "Output report to given file") do |file|
            options[:output_file] = file
          end

          opts.on("--format FORMAT", "Output report to given format (html & yml available). Html by default.") do |format|
            options[:formatter] = format
          end

          opts.on_tail("-h", "--help", "Show this help") do
            puts opts
            exit
          end

          opts.on_tail("--version", "Show version") do
            puts "Gemsurance version #{Gemsurance::VERSION}"
            exit
          end
        end

        opts.parse!(argv)
        options
      end
    end
  end
end
