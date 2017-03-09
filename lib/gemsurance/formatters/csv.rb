require 'csv'
module Gemsurance
  module Formatters
    class Csv < Base
      def format
        @extension = "csv"

        file = ""
        file << CSV.generate_line(GemInfoRetriever::GemInfo.attributes)

        sorted_gems.each do |gem|
          file << gem.to_csv
        end
        file
      end
    end
  end
end
