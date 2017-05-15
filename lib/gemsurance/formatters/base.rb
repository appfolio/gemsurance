module Gemsurance
  module Formatters
    class Base
      def initialize(gem_infos, version)
        @gem_infos = gem_infos
        @ruby_version = version
      end

      def output_path
        File.join(File.dirname(__FILE__), "../templates/output.#{@extension}.erb")
      end

      def sorted_gems
        @gem_infos.sort{ |a, b| a.name.downcase <=> b.name.downcase }
      end
    end
  end
end
