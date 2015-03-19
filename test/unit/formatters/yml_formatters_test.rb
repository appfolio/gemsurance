require 'helper'

module Gemsurance
  module Formatters
    class YmlTest < Test::Unit::TestCase
      def test_yml_format
        generate_gem_infos

        yml = YAML::load(Formatters::Yml.new(@gem_infos).format)

        cool_gem = yml["cool"]
        assert cool_gem
        assert_equal "2.3.4", cool_gem["bundle_version"]
        assert_equal "2.3.5", cool_gem["newest_version"]
        assert_equal "outofdate", cool_gem["status"]
        refute cool_gem["vulnerabilities"]

        dangerous_gem = yml["dangerous"]
        assert dangerous_gem
        assert_equal "8.4.7", dangerous_gem["bundle_version"]
        assert_equal "8.4.8", dangerous_gem["newest_version"]
        assert_equal "vulnerable", dangerous_gem["status"]
        assert dangerous_gem["vulnerabilities"]
        assert_equal "2013-0156", dangerous_gem["vulnerabilities"].first["cve"]

        sweet_gem = yml["sweet"]
        assert sweet_gem
        assert_equal "1.2.3", sweet_gem["bundle_version"]
        assert_equal "1.2.3", sweet_gem["newest_version"]
        assert_equal "uptodate", sweet_gem["status"]
        refute sweet_gem["vulnerabilities"]
      end
    end
  end
end
