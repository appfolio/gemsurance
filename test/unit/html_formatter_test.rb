require 'helper'

module Gemsurance
  class HtmlFormatterTest < Test::Unit::TestCase
    def test_format
      gem_infos = [
        GemInfoRetriever::GemInfo.new('sweet', Gem::Version.new('1.2.3'), Gem::Version.new('1.2.3'), 'http://homepage.com', 'http://source.com', 'http://documentation.com'),
        GemInfoRetriever::GemInfo.new('cool', Gem::Version.new('2.3.4'), Gem::Version.new('2.3.5'), nil, nil, nil, GemInfoRetriever::GemInfo::STATUS_OUTDATED)
      ]
      vulnerable_gem = GemInfoRetriever::GemInfo.new('dangerous', Gem::Version.new('8.4.7'), Gem::Version.new('8.4.8'), nil, nil, nil, GemInfoRetriever::GemInfo::STATUS_VULNERABLE)
      vulnerable_gem.add_vulnerability!(Vulnerability.new(vulnerability_yaml))
      gem_infos << vulnerable_gem
      actual_html = HtmlFormatter.new(gem_infos).format

      expected = Nokogiri::HTML(expected_html).at_css('.wrapper').to_s
      actual = Nokogiri::HTML(actual_html).at_css('.wrapper').to_s

      assert_equal expected, actual
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

    def expected_html
<<-HTML
<div class="wrapper">
    <h1>Gemsurance Report</h1>
    <table class="table">
      <thead>
        <tr>
          <th>Gem Name</th>
          <th>Bundle Version</th>
          <th>Newest Version</th>
          <th>Status</th>
          <th>Detailed Status</th>
          <th>Links</th>
        </tr>
      </thead>
      <tbody>
        
          
          <tr class="warning">
            <td>cool</td>
            <td>2.3.4</td>
            <td>2.3.5</td>
            <td>
              
                <strong>Out of Date</strong>
              
            </td>
            <td>
              <div style="width:200px">
                
              </div>
            </td>
            <td>
              
              
              
            </td>
          </tr>
        
          
          <tr class="danger">
            <td>dangerous</td>
            <td>8.4.7</td>
            <td>8.4.8</td>
            <td>
              
                <strong>Vulnerable</strong>
              
            </td>
            <td>
              <div style="width:200px">
                
                  
                    <strong>Ruby on Rails params_parser.rb Action Pack Type Casting Parameter Parsing
Remote Code Execution
</strong>
                    <dl>
                      <dt>CVE</dt>
                      <dd>2013-0156</dd>
                      <dt>URL</dt>
                      <dd><a href="http://osvdb.org/show/osvdb/89026">More Info</a></dd>
                      <dt>Patched Versions</dt>
                      <dd>~&gt; 2.3.15, ~&gt; 3.0.19, ~&gt; 3.1.10, &gt;= 3.2.11</dd>
                    </dl>
                  
                
              </div>
            </td>
            <td>
              
              
              
            </td>
          </tr>
        
          
          <tr class="success">
            <td>sweet</td>
            <td>1.2.3</td>
            <td>1.2.3</td>
            <td>
              
                Up-to-Date
              
            </td>
            <td>
              <div style="width:200px">
                
              </div>
            </td>
            <td>
              
                <a href="http://homepage.com" target="_blank" class="link homepage_uri" title="Homepage"></a>
              
              
                <a href="http://source.com" target="_blank" class="link source_code_uri" title="Source"></a>
              
              
                <a href="http://documentation.com" target="_blank" class="link documentation_uri" title="Docs"></a>
              
            </td>
          </tr>
        
      </tbody>
    </table>
  </div>
HTML
    end
  end
end
