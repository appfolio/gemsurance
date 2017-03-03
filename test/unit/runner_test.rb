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

  def test_report_without_previous_run
    runner = Gemsurance::Runner.new
    assert_raise SystemExit do
      runner.report
    end
  end

  def test_report_with_vulnerabilities
    runner = Gemsurance::Runner.new

    vulnerable_gem = Gemsurance::GemInfoRetriever::GemInfo.new(
      'actionpack',
      Gem::Version.new('3.2.14'),
      Gem::Version.new('4.0.2'),
      true,
      'http://homepage.com',
      'http://source.com',
      'http://documentation.com',
      Gemsurance::GemInfoRetriever::GemInfo::STATUS_VULNERABLE
    )

    runner.instance_variable_set(:@gem_infos_loaded, true)
    runner.instance_variable_set(:@gem_infos, [vulnerable_gem])
    runner.expects(:generate_report).returns(true)

    assert_raise SystemExit do
      runner.report
    end
  end

  def test_report_with_outdated_gem
    runner = Gemsurance::Runner.new(fail_outdated: true)

    outdated_gem = Gemsurance::GemInfoRetriever::GemInfo.new(
      'actionpack',
      Gem::Version.new('3.2.14'),
      Gem::Version.new('4.0.2'),
      true,
      'http://homepage.com',
      'http://source.com',
      'http://documentation.com',
      Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
    )

    runner.instance_variable_set(:@gem_infos_loaded, true)
    runner.instance_variable_set(:@gem_infos, [outdated_gem])
    runner.expects(:generate_report).returns(true)

    assert_raise SystemExit do
      runner.report
    end
  end

  def test_report_with_outdated_gem_do_not_fail
    runner = Gemsurance::Runner.new(fail_outdated: false)

    outdated_gem = Gemsurance::GemInfoRetriever::GemInfo.new(
      'actionpack',
      Gem::Version.new('3.2.14'),
      Gem::Version.new('4.0.2'),
      true,
      'http://homepage.com',
      'http://source.com',
      'http://documentation.com',
      Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
    )

    runner.instance_variable_set(:@gem_infos_loaded, true)
    runner.instance_variable_set(:@gem_infos, [outdated_gem])
    runner.expects(:generate_report).returns(true)

    assert_nothing_raised do
      runner.report
    end
  end

  def test_run_with_not_frozen_bundler
    runner = Gemsurance::Runner.new
    stub_external_calls(runner)

    Bundler.settings.expects(:set_local).never

    runner.run
  end

  def test_run_with_frozen_bundler
    runner = Gemsurance::Runner.new
    stub_external_calls(runner)

    Bundler.settings.set_local(:frozen, "1")
    Bundler.settings.expects(:set_local).twice

    runner.run
  ensure
    Bundler.settings.unstub(:set_local)
    Bundler.settings.set_local(:frozen, "0")
  end

  def test_report_without_vulnerabilities
    runner = Gemsurance::Runner.new

    runner.instance_variable_set(:@gem_infos_loaded, true)
    runner.instance_variable_set(:@gem_infos, [])
    runner.expects(:generate_report).returns(true)

    runner.report
  end

  def test_add_vulnerability_data
    runner = Gemsurance::Runner.new
    gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new(
        'actionpack',
        Gem::Version.new('3.2.14'),
        Gem::Version.new('4.0.2'),
        true,
        'http://homepage.com',
        'http://source.com',
        'http://documentation.com',
        Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
      )
    ]

    runner.instance_variable_set(:@gem_infos, gem_infos)
    runner.send(:add_vulnerability_data, './test/unit/vulnerabilities/gems')

    updated_gem_info = gem_infos.first
    assert updated_gem_info.vulnerable?
    expected_vulnerability_yml = File.read(File.join(File.dirname(__FILE__), 'vulnerabilities/gems/actionpack/vulnerability2.yml'))
    assert_equal [Gemsurance::Vulnerability.new(expected_vulnerability_yml)], updated_gem_info.vulnerabilities
  end

  def test_add_whitelisted_vulnerability_data_and_cve
    runner = Gemsurance::Runner.new
    gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new(
        'actionpack',
        Gem::Version.new('3.2.14'),
        Gem::Version.new('4.0.2'),
        true,
        'http://homepage.com',
        'http://source.com',
        'http://documentation.com',
        Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
      )
    ]

    Gemsurance::Vulnerability.any_instance.stubs(:osvdb).returns(nil)

    should_return = ['3.2.14', '4.0.2']

    runner.stubs(:fetch_whitelisted_versions_for).with('actionpack', '2013-6416', nil).returns(should_return)
    runner.stubs(:fetch_whitelisted_versions_for).with('actionpack', '2013-6417', nil).returns(should_return)
    runner.instance_variable_set(:@gem_infos, gem_infos)
    runner.send(:add_vulnerability_data, './test/unit/vulnerabilities/gems')

    updated_gem_info = gem_infos.first
    assert_false updated_gem_info.vulnerable?
    assert_equal [], updated_gem_info.vulnerabilities
  end

  def test_add_whitelisted_vulnerability_data_and_osvdb
    runner = Gemsurance::Runner.new
    gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new(
        'actionpack',
        Gem::Version.new('3.2.14'),
        Gem::Version.new('4.0.2'),
        true,
        'http://homepage.com',
        'http://source.com',
        'http://documentation.com',
        Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
      )
    ]

    Gemsurance::Vulnerability.any_instance.stubs(:cve).returns(nil)

    should_return = ['3.2.14', '4.0.2']

    runner.stubs(:fetch_whitelisted_versions_for).with('actionpack', nil, 100526).returns(should_return)
    runner.stubs(:fetch_whitelisted_versions_for).with('actionpack', nil, 100527).returns(should_return)
    runner.instance_variable_set(:@gem_infos, gem_infos)
    runner.send(:add_vulnerability_data, './test/unit/vulnerabilities/gems')

    updated_gem_info = gem_infos.first
    assert_false updated_gem_info.vulnerable?
    assert_equal [], updated_gem_info.vulnerabilities
  end

  def test_add_whitelisted_vulnerability_data_and_all_nil
    runner = Gemsurance::Runner.new
    gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new(
        'actionpack',
        Gem::Version.new('3.2.14'),
        Gem::Version.new('4.0.2'),
        true,
        'http://homepage.com',
        'http://source.com',
        'http://documentation.com',
        Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED
      )
    ]

    Gemsurance::Vulnerability.any_instance.stubs(:cve).returns(nil)
    Gemsurance::Vulnerability.any_instance.stubs(:osvdb).returns(nil)

    should_return = nil

    runner.stubs(:fetch_whitelisted_versions_for).with('actionpack', nil, nil).returns(should_return)
    runner.stubs(:fetch_whitelisted_versions_for).with('actionpack', nil, nil).returns(should_return)
    runner.instance_variable_set(:@gem_infos, gem_infos)
    runner.send(:add_vulnerability_data, './test/unit/vulnerabilities/gems')

    updated_gem_info = gem_infos.first
    assert updated_gem_info.vulnerable?
    expected_vulnerability_yml = File.read(File.join(File.dirname(__FILE__), 'vulnerabilities/gems/actionpack/vulnerability2.yml'))
    assert_equal [Gemsurance::Vulnerability.new(expected_vulnerability_yml)], updated_gem_info.vulnerabilities
  end

  private
    def stub_external_calls(runner)
      runner.stubs(:retrieve_vulnerability_data)
      runner.stubs(:add_vulnerability_data)
      Bundler::Definition.any_instance.stubs(:resolve_remotely!)
      Gemsurance::GemInfoRetriever.any_instance.stubs(:retrieve)
    end
end
