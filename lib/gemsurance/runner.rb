module Gemsurance
  class Runner
    def self.run(formatter = :html, output_file = 'gemsurance_report.html')
      # discover what gems are in our bundle
      puts "Retrieving outdated gems data..."
      outdated_gems = self.outdated
      
      puts "Retrieving latest vulnerability data..."
      if File.exists?('./tmp/vulnerabilities')
        g = Git.open('./tmp/vulnerabilities')
        g.pull
      else
        _ = Git.clone('https://github.com/rubysec/ruby-advisory-db', './tmp/vulnerabilities')
      end
      
      puts "Parsing vulnerability data..."
      outdated_gems.each do |gem_data|
        vulnerability_directory = "./tmp/vulnerabilities/gems/#{gem_data[:name]}"
        if File.exists?(vulnerability_directory)
          Dir.foreach(vulnerability_directory) do |yaml_file|
            next if yaml_file =~ /\A\./
            vulnerability = Vulnerability.new(File.read(File.join(vulnerability_directory, yaml_file)))
            # are we impacted? if so, add details to gem_data
            current_version = gem_data[:current_version]
            
            unless vulnerability.patched_versions.any?{|version| Gem::Requirement.new(version).satisfied_by?(current_version)}
              gem_data[:vulnerabilities] ||= []
              gem_data[:vulnerabilities] << vulnerability
            end
          end
        end
      end
      
      puts "Generating report..."
      output_data = Gemsurance.const_get(:"#{formatter.to_s.capitalize}Formatter").new(outdated_gems).format
      
      File.open(output_file, "w+") do |file|
         file.puts output_data
      end
      puts "Generated report #{output_file}."
    end
  
    def self.outdated(options = {})
      # Bundler.definition.validate_ruby!
      current_specs = Bundler.load.specs
      definition = Bundler.definition(true)
      definition.resolve_remotely!

      # Bundler.ui.info ""
      # if options["pre"]
      #   Bundler.ui.info "Outdated gems included in the bundle (including pre-releases):"
      # else
      #   Bundler.ui.info "Outdated gems included in the bundle:"
      # end
    
      outdated = []

      current_specs.each do |current_spec|
        active_spec = definition.index[current_spec.name].sort_by { |b| b.version }

        if !current_spec.version.prerelease? && !options[:pre] && active_spec.size > 1
          active_spec = active_spec.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? }
        end

        active_spec = active_spec.last
        next if active_spec.nil?

        gem_outdated = Gem::Version.new(active_spec.version) > Gem::Version.new(current_spec.version)
        #git_outdated = current_spec.git_version != active_spec.git_version
        if gem_outdated #|| git_outdated
          # spec_version    = "#{active_spec.version}#{active_spec.git_version}"
          # current_version = "#{current_spec.version}#{current_spec.git_version}"
          outdated << {:name => active_spec.name, :current_version => current_spec.version, :newest_version => active_spec.version}
        end
      end
      outdated
    end
  end
end