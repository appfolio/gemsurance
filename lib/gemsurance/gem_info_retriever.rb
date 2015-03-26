module Gemsurance
  class GemInfoRetriever
    class GemInfo
      STATUS_OUTDATED   = 'outdated'
      STATUS_CURRENT    = 'current'
      STATUS_VULNERABLE = 'vulnerable'

      attr_reader :name, :current_version, :newest_version, :in_gem_file, :vulnerabilities,
                  :homepage_uri, :source_code_uri, :documentation_uri

      def initialize(name, current_version, newest_version, in_gem_file, homepage_uri, source_code_uri, documentation_uri, status = STATUS_CURRENT)
        @name = name
        @current_version = current_version
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

    def initialize(specs, dependencies)
      @specs = specs
      @dependencies = dependencies
    end

    def retrieve(options = {})
      gem_infos = []

      @specs.each do |current_spec|
        active_spec = ::Gems.versions(current_spec.name).sort_by { |b| b[:number] }

        if !current_spec.version.prerelease? && !options[:pre] && active_spec.size > 1
          active_spec = active_spec.delete_if { |b| b[:prerelease] }
        end

        active_spec = active_spec.last
        next if active_spec.nil?

        gem_outdated = Gem::Version.new(active_spec[:number]) > Gem::Version.new(current_spec.version)

        info = ::Gems.info(current_spec.name)
        homepage_uri      = info['homepage_uri']
        documentation_uri = info['documentation_uri']
        source_code_uri   = info['source_code_uri']

        in_gem_file = @dependencies.any?{|d| d.name == current_spec.name}
        if gem_outdated
          gem_infos << GemInfo.new(current_spec.name, current_spec.version, Gem::Version.new(active_spec[:number]), in_gem_file, homepage_uri, documentation_uri, source_code_uri, GemInfo::STATUS_OUTDATED)
        else
          gem_infos << GemInfo.new(current_spec.name, current_spec.version, current_spec.version, in_gem_file, homepage_uri, documentation_uri, source_code_uri)
        end
      end
      gem_infos
    end
  end
end
