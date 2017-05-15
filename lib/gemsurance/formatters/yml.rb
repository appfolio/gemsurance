module Gemsurance
  module Formatters
    class Yml < Base
      def format
        @extension = "yml"

        (sorted_gems.unshift([{name: 'ruby', version: @ruby_version }])).to_yaml
      end
    end
  end
end
