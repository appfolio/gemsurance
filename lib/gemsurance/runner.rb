module Gemsurance
  class Runner
    class GemVersionData < (Struct.new(:name, :current_version, :newest_version))
    end
    
    def self.run
      # discover what gems are in our bundle
      outdated_gems = self.outdated
      puts outdated_gems.inspect
      # figure out what the newest version of each is and what version we're on
      
      # find out if there are any vulnerabilities
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
          outdated << GemVersionDate.new(active_spec.name, current_version, spec_version)
        end
      end
      outdated
    end
  end
end