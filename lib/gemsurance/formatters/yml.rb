module Gemsurance
  module Formatters
    class Yml < Base
      def format
        @extension = "yml"
        sorted_gems.to_yaml
      end
    end
  end
end
