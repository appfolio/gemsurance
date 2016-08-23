module Gemsurance
  class GemInfoRetriever
    class GemInfo
      STATUS_OUTDATED   = 'outdated'
      STATUS_CURRENT    = 'current'
      STATUS_VULNERABLE = 'vulnerable'
      
      attr_reader :name, :current_version, :current_version_release_date, :newest_version, :in_gem_file, :vulnerabilities,
                  :homepage_uri, :source_code_uri, :documentation_uri
      
      def initialize(name, current_version, newest_version, in_gem_file, homepage_uri, source_code_uri, documentation_uri, status = STATUS_CURRENT, current_version_release_date = nil)
        @name = name
        @current_version = current_version
        @current_version_release_date = current_version_release_date
        @newest_version = newest_version
        @in_gem_file = in_gem_file
        @homepage_uri = homepage_uri
        @documentation_uri = documentation_uri
        @source_code_uri = source_code_uri
        @status = status
        @vulnerabilities = []
        
      end
      
      def add_vulnerability!(vulnerability)
        @status = STATUS_VULNERABLE
        @vulnerabilities << vulnerability
      end
      
      def outdated?
        @status == STATUS_OUTDATED
      end
      
      def current?
        @status == STATUS_CURRENT
      end
      
      def vulnerable?
        @status == STATUS_VULNERABLE
      end

      def ==(other)
        @name == other.name &&
          @current_version == other.current_version &&
          @newest_version == other.newest_version &&
          @status == other.instance_variable_get(:@status) &&
          @vulnerabilities == other.vulnerabilities
      end
    end
    
    def initialize(specs, dependencies, bundle_definition)
      @specs = specs
      @dependencies = dependencies
      @bundle_definition = bundle_definition
    end
    
    def retrieve(options = {})
      gem_infos = []
      
      @specs.each do |current_spec|
        active_spec = @bundle_definition.index[current_spec.name].sort_by { |b| b.version }

        if !current_spec.version.prerelease? && !options[:pre] && active_spec.size > 1
          active_spec = active_spec.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? }
        end

        active_spec = active_spec.last
        next if active_spec.nil?

        gem_outdated = Gem::Version.new(active_spec.version) > Gem::Version.new(current_spec.version)
        git_outdated = current_spec.git_version != active_spec.git_version

        info = ::Gems.info(active_spec.name)
        
        # TODO: to speed things up, avoid ::Gems.info call and instead figure out how to reliably
        # use the output from ::Gems.versions. I'm not sure yet if relying on the timestamps (built_at, created_at)
        # is good enough. It /looks/ the active version is at index 0
        # but this should be verified (rubygems API doc or source).
        versions = ::Gems.versions(active_spec.name)
        current_version = versions.find { |version| version.fetch("number") == current_spec.version.to_s }
        
        # NOTE: I'm picking built_at based on a test on awesome_print 1.0.2, which gives 2011-12-20 for built_at
        # and 2011-12-21 for created_at, and https://rubygems.org/gems/awesome_print/versions
        # shows December 20, 2011.
        current_version_release_date = current_version ? Time.parse(current_version.fetch("built_at")) : nil
        
        homepage_uri      = info['homepage_uri']
        documentation_uri = info['documentation_uri']
        source_code_uri   = info['source_code_uri']

        # TODO: handle git versions
        # spec_version    = "#{active_spec.version}#{active_spec.git_version}"
        # current_version = "#{current_spec.version}#{current_spec.git_version}"
        in_gem_file = @dependencies.any?{|d| d.name == active_spec.name}
        if gem_outdated || git_outdated
          gem_infos << GemInfo.new(active_spec.name, current_spec.version, active_spec.version, in_gem_file, homepage_uri, documentation_uri, source_code_uri, GemInfo::STATUS_OUTDATED, current_version_release_date)
        else
          gem_infos << GemInfo.new(active_spec.name, current_spec.version, current_spec.version, in_gem_file, homepage_uri, documentation_uri, source_code_uri, GemInfo::STATUS_CURRENT, current_version_release_date)
        end
      end
      gem_infos
    end
  end
end
