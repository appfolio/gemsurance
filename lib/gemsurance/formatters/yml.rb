module Gemsurance
  module Formatters
    class Yml < Base
      def format
        @extension = "yml"
        gem_hash = {}

        sorted_gems.each do |gem_info|
          gem_hash[gem_info.name] = gem_info.to_hash
        end

        gem_hash.to_yaml
      end
    end
  end
end
