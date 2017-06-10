require 'csv'
module Gemsurance
  module Formatters
    class Csv < Base
      def format
        @extension = "csv"

        file = ""
        title_attributes = GemInfoRetriever::GemInfo::GEM_ATTRIBUTES.map {|attr| attr.to_s }
        file << CSV.generate_line(title_attributes)

        sorted_gems.each do |gem|
          file << gem.to_csv
        end
        file
      end
    end
  end
end
