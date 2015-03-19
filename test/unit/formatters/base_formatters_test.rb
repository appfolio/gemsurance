require 'helper'

module Gemsurance
  module Formatters
    class BaseTest < Test::Unit::TestCase
      def test_output_path
        generate_gem_infos

        formatter = Gemsurance::Formatters::Base.new(@gem_infos)
        formatter.instance_variable_set(:@extension, "ext")
        assert formatter.output_path.include?("../templates/output.ext.erb")
      end

      def test_sorted_gems
        generate_gem_infos

        assert_equal ["sweet", "cool", "dangerous"], @gem_infos.map(&:name)
        formatter = Gemsurance::Formatters::Base.new(@gem_infos)
        assert_equal ["cool", "dangerous", "sweet"], formatter.sorted_gems.map(&:name)
      end
    end
  end
end
