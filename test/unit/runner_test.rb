require 'helper'

class RunnerTest < Test::Unit::TestCase
  # TODO add integration test

  def test_add_vulnerability_data
    runner = Gemsurance::Runner.new
    gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new(
        'actionpack',
        Gem::Version.new('3.2.14'),
        Gem::Version.new('4.0.2'),
        'http://homepage.com',
        'http://source.com',
        'http://documentation.com',
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
