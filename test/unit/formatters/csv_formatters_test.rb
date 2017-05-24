require 'helper'
require 'json'

module Gemsurance
  module Formatters
    class CsvTest < Test::Unit::TestCase
      def test_csv_format
        generate_gem_infos

        csv = Formatters::Csv.new(@gem_infos).format

        csv_arr = CSV.parse(csv)

        headers = csv_arr[0]
        cool_gem = csv_arr[1]
        dangerous_gem = csv_arr[2]
        sweet_gem = csv_arr[3]

        assert headers
        assert_equal GemInfoRetriever::GemInfo::GEM_ATTRIBUTES.map {|attr| attr.to_s }, headers

        assert sweet_gem
        assert_equal "sweet", sweet_gem[0]
        assert_equal "1.2.3", sweet_gem[1]
        assert_equal "1.2.3", sweet_gem[2]
        assert_equal 'true', sweet_gem[3]
        assert_equal 'http://homepage.com', sweet_gem[4]
        assert_equal 'http://source.com', sweet_gem[5]
        assert_equal 'http://documentation.com', sweet_gem[6]
        assert_equal "uptodate", sweet_gem[7]
        assert_equal '',  sweet_gem[8]

        assert cool_gem
        assert_equal "cool", cool_gem[0]
        assert_equal "2.3.4", cool_gem[1]
        assert_equal "2.3.5", cool_gem[2]
        assert_equal "outofdate", cool_gem[7]
        assert_equal '',  cool_gem[8]

        assert dangerous_gem
        assert_equal "dangerous", dangerous_gem[0]
        assert_equal "8.4.7", dangerous_gem[1]
        assert_equal "8.4.8", dangerous_gem[2]
        assert_equal "vulnerable", dangerous_gem[7]
        assert dangerous_gem[8]
        vulns = JSON.parse dangerous_gem[8]
        assert_equal "2013-0156", vulns.first["cve"]
      end
    end
  end
end
