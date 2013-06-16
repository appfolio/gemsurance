module Gemsurance
  class Runner
    def initialize(options = {})
      @formatter   = options.delete(:formatter) || :html
      @output_file = options.delete(:output_file) || 'gemsurance_report.html'
      @options     = options
    end

    def run
      bundled_gem_infos = retrieve_bundled_gem_infos

      retrieve_vulnerability_data

      add_vulnerability_data(bundled_gem_infos)

      generate_report(bundled_gem_infos)

      exit 1 if bundled_gem_infos.any? { |info| info.vulnerable? }
    end

  private

    def retrieve_bundled_gem_infos
      puts "Retrieving gem version information..."

      current_specs = Bundler.load.specs
      definition    = Bundler.definition(true)
      definition.resolve_remotely!

      GemInfoRetriever.new(current_specs, definition).retrieve(:pre => @options[:pre])
    end

    def retrieve_vulnerability_data
      puts "Retrieving latest vulnerability data..."
      if File.exists?('./tmp/vulnerabilities')
        g = Git.open('./tmp/vulnerabilities')
        g.pull
      else
        Git.clone('https://github.com/rubysec/ruby-advisory-db', './tmp/vulnerabilities')
      end
    end

    def add_vulnerability_data(gem_infos)
      puts "Reading vulnerability data..."
      gem_infos.each do |gem_info|
        vulnerability_directory = "./tmp/vulnerabilities/gems/#{gem_info.name}"
        if File.exists?(vulnerability_directory)
          Dir.foreach(vulnerability_directory) do |yaml_file|
            next if yaml_file =~ /\A\./
            vulnerability = Vulnerability.new(File.read(File.join(vulnerability_directory, yaml_file)))
            # are we impacted? if so, add details to gem_data
            unless vulnerability.patched_versions.any? { |version| Gem::Requirement.new(version).satisfied_by?(gem_info.current_version) }
              gem_info.add_vulnerability!(vulnerability)
            end
          end
        end
      end
    end

    def generate_report(gem_infos)
      puts "Generating report..."
      output_data = Gemsurance.const_get(:"#{@formatter.to_s.capitalize}Formatter").new(gem_infos).format

      File.open(@output_file, "w+") do |file|
        file.puts output_data
      end
      puts "Generated report #{@output_file}."
    end
  end
end
