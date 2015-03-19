$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'

require 'gemsurance'
require 'test/unit'
require "mocha/setup"
require 'nokogiri'

class Test::Unit::TestCase
  def generate_gem_infos
    @gem_infos = [
      Gemsurance::GemInfoRetriever::GemInfo.new('sweet', Gem::Version.new('1.2.3'), Gem::Version.new('1.2.3'), true, 'http://homepage.com', 'http://source.com', 'http://documentation.com'),
      Gemsurance::GemInfoRetriever::GemInfo.new('cool', Gem::Version.new('2.3.4'), Gem::Version.new('2.3.5'), false, nil, nil, nil, Gemsurance::GemInfoRetriever::GemInfo::STATUS_OUTDATED)
    ]
    vulnerable_gem = Gemsurance::GemInfoRetriever::GemInfo.new('dangerous', Gem::Version.new('8.4.7'), Gem::Version.new('8.4.8'), false, nil, nil, nil, Gemsurance::GemInfoRetriever::GemInfo::STATUS_VULNERABLE)
    vulnerable_gem.add_vulnerability!(Gemsurance::Vulnerability.new(vulnerability_yaml))
    @gem_infos << vulnerable_gem
  end

  private

  def vulnerability_yaml
<<-YAML
---
gem: dangerous
cve: 2013-0156
osvdb: 89026
url: http://osvdb.org/show/osvdb/89026
title: |
  Ruby on Rails params_parser.rb Action Pack Type Casting Parameter Parsing
  Remote Code Execution

description: |
  Ruby on Rails contains a flaw in params_parser.rb of the Action Pack.
  The issue is triggered when a type casting error occurs during the parsing
  of parameters. This may allow a remote attacker to potentially execute
  arbitrary code.
date: 2013-04-01

cvss_v2: 10.0

patched_versions:
  - ~> 2.3.15
  - ~> 3.0.19
  - ~> 3.1.10
  - ">= 3.2.11"
YAML
  end
end
