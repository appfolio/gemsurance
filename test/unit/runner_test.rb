require 'helper'

class RunnerTest < Test::Unit::TestCase
  # TODO add integration test

  def test_output_file_option_default
    runner = Gemsurance::Runner.new
    assert_equal 'gemsurance_report.html', runner.instance_variable_get(:@output_file)
  end

  def test_output_file_option_custom
    runner = Gemsurance::Runner.new(:output_file => 'custom.html')
    assert_equal 'custom.html', runner.instance_variable_get(:@output_file)
  end

  def test_add_vulnerability_data
    runner = Gemsurance::Runner.new
    gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new(
        'actionpack',
        Gem::Version.new('3.2.14'),
        Gem::Version.new('4.0.2'),
        Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
      )
    ]

    runner.send(:add_vulnerability_data, gem_infos, './test/unit/vulnerabilities/gems')

    updated_gem_info = gem_infos.first
    assert updated_gem_info.vulnerable?
    expected_vulnerability_yml = File.read(File.join(File.dirname(__FILE__), 'vulnerabilities/gems/actionpack/vulnerability2.yml'))
    assert_equal [Gemsurance::Vulnerability.new(expected_vulnerability_yml)], updated_gem_info.vulnerabilities
  end
end
