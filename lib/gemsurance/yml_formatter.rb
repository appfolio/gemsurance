module Gemsurance
  class YmlFormatter
    def initialize(gem_infos)
      @gem_infos = gem_infos
    end

    def format
      ERB.new(File.read(File.join(File.dirname(File.expand_path(__FILE__)), 'templates/output.yml.erb')), nil, '-').result(binding)
    end
  end
end
