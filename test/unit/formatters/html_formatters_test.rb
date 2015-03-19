require 'helper'

module Gemsurance
  module Formatters
    class HtmlTest < Test::Unit::TestCase
      def test_html_format
        generate_gem_infos

        html = Nokogiri::HTML(Formatters::Html.new(@gem_infos).format)

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
    end
  end
end
