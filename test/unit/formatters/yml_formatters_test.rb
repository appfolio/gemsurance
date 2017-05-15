require 'helper'

module Gemsurance
  module Formatters
    class YmlTest < Test::Unit::TestCase
      def test_yml_format
        generate_gem_infos

        yml = YAML::load(Formatters::Yml.new(@gem_infos).format)

        cool_gem = yml.detect { |gem| gem.name == "cool" }
        assert cool_gem
        assert_equal "2.3.4", cool_gem.current_version.version
        assert_equal "2.3.5", cool_gem.newest_version.version
        assert_equal "outdated", cool_gem.status
        assert_equal [], cool_gem.vulnerabilities

        dangerous_gem = yml.detect { |gem| gem.name == "dangerous" }
        assert dangerous_gem
        assert_equal "8.4.7", dangerous_gem.current_version.version
        assert_equal "8.4.8", dangerous_gem.newest_version.version
        assert_equal "vulnerable", dangerous_gem.status
        assert dangerous_gem.vulnerabilities
        assert_equal "2013-0156", dangerous_gem.vulnerabilities.first.cve

        sweet_gem = yml.detect { |gem| gem.name == "sweet" }
        assert sweet_gem
        assert_equal "1.2.3", sweet_gem.current_version.version
        assert_equal "1.2.3", sweet_gem.newest_version.version
        assert_equal "current", sweet_gem.status
        assert_equal [], sweet_gem.vulnerabilities
      end
    end
  end
end
