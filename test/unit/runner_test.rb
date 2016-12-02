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

  private
    def stub_external_calls(runner)
      runner.stubs(:retrieve_vulnerability_data)
      runner.stubs(:add_vulnerability_data)
      Bundler::Definition.any_instance.stubs(:resolve_remotely!)
      Gemsurance::GemInfoRetriever.any_instance.stubs(:retrieve)
    end
end
