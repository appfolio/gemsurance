require 'helper'
require 'gemsurance/cli'

class CliTest < Test::Unit::TestCase

  def test_default_options
    options = Gemsurance::Cli.parse
    assert_equal ({}), options
  end

  def test_option_pre
    options = Gemsurance::Cli.parse('--pre')
    assert_equal true, options[:pre]
  end

  def test_option_fail_outdated
    options = Gemsurance::Cli.parse('--fail-outdated')
    assert_equal true, options[:fail_outdated]
  end

  def test_option_output_with_arg
    options = Gemsurance::Cli.parse('--output', 'file.html')
    assert_equal 'file.html', options[:output_file]
  end

  def test_option_output_without_arg
    assert_raise OptionParser::MissingArgument do
      Gemsurance::Cli.parse('--output')
    end
  end

end
