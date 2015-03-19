module Gemsurance
  class Runner
    def initialize(options = {})
      @formatter   = options.delete(:formatter) || :html
      @output_file = options.delete(:output_file) || "gemsurance_report.#{@formatter}"
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

      bundler = Bundler.load
      current_specs = bundler.specs
      dependencies = bundler.dependencies
      definition    = Bundler.definition(true)
      definition.resolve_remotely!

      GemInfoRetriever.new(current_specs, dependencies, definition).retrieve(:pre => @options[:pre])
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

    def add_vulnerability_data(gem_infos, vulnerabilities_directory = './tmp/vulnerabilities/gems')
      puts "Reading vulnerability data..."
      gem_infos.each do |gem_info|
        vulnerability_directory = File.join(vulnerabilities_directory, gem_info.name)
        if File.exists?(vulnerability_directory)
          Dir.foreach(vulnerability_directory) do |yaml_file|
            next if yaml_file =~ /\A\./
            vulnerability = Vulnerability.new(File.read(File.join(vulnerability_directory, yaml_file)))

            # are we impacted? if so, add details to gem_data
            current_version_satisfies_requirement = lambda do |version|
              Gem::Requirement.new(version.split(',')).satisfied_by?(gem_info.current_version)
            end

            current_version_is_affected = (vulnerability.unaffected_versions || []).none?(&current_version_satisfies_requirement)
            current_version_isnt_patched = (vulnerability.patched_versions || []).none?(&current_version_satisfies_requirement)

            if current_version_is_affected && current_version_isnt_patched
              gem_info.add_vulnerability!(vulnerability)
            end
          end
        end
      end
    end

    def generate_report(gem_infos)
      puts "Generating report..."
      output_data = Gemsurance::Formatters.const_get(:"#{@formatter.to_s.capitalize}").new(gem_infos).format

      File.open(@output_file, "w+") do |file|
        file.puts output_data
      end
      puts "Generated report #{@output_file}."
    end
  end
end
