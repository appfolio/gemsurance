require 'helper'

module Gemsurance
  class HtmlFormatterTest < Test::Unit::TestCase
    def test_format
      gem_infos = [
        GemInfoRetriever::GemInfo.new('sweet', Gem::Version.new('1.2.3'), Gem::Version.new('1.2.3'), true),
        GemInfoRetriever::GemInfo.new('cool', Gem::Version.new('2.3.4'), Gem::Version.new('2.3.5'), false, GemInfoRetriever::GemInfo::STATUS_OUTDATED)
      ]
      vulnerable_gem = GemInfoRetriever::GemInfo.new('dangerous', Gem::Version.new('8.4.7'), Gem::Version.new('8.4.8'), false, GemInfoRetriever::GemInfo::STATUS_VULNERABLE)
      vulnerable_gem.add_vulnerability!(Vulnerability.new(vulnerability_yaml))
      gem_infos << vulnerable_gem

      html = Nokogiri::HTML(HtmlFormatter.new(gem_infos).format)

      tds = html.css('tr.warning td')
      assert_equal 'cool', tds[0].text.strip
      assert_equal '2.3.4', tds[1].text.strip
      assert_equal '2.3.5', tds[2].text.strip
      assert_equal 'Out of Date', tds[3].at('strong').text.strip
      assert_equal '', tds[4].text.strip

      tds = html.css('tr.danger td')
      assert_equal 'dangerous', tds[0].text.strip
      assert_equal '8.4.7', tds[1].text.strip
      assert_equal '8.4.8', tds[2].text.strip
      assert_equal 'Vulnerable', tds[3].at('strong').text.strip
      assert_match /CVE.*2013-0156/m, tds[4].text.strip

      tds = html.css('tr.success td')
      assert_equal 'sweet', tds[0].at('strong').text.strip
      assert_equal '1.2.3', tds[1].text.strip
      assert_equal '1.2.3', tds[2].text.strip
      assert_equal 'Up-to-Date', tds[3].text.strip
      assert_equal '', tds[4].text.strip

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
end
