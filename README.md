[![Build Status](https://api.travis-ci.org/appfolio/gemsurance.svg?branch=master)](http://travis-ci.org/appfolio/gemsurance) [![Gem Version](https://badge.fury.io/rb/gemsurance.svg)](http://badge.fury.io/rb/gemsurance) [![Code Climate](https://codeclimate.com/github/appfolio/gemsurance.png)](https://codeclimate.com/github/appfolio/gemsurance)
# Gemsurance: Insurance for your Gems

Gemsurance is a tool for monitoring if any of your Ruby Gems are out-of-date or vulnerable. It uses [Bundler](https://github.com/bundler/bundler) and the [Ruby Advisory Database](https://github.com/rubysec/ruby-advisory-db) to do so. It's similar to bundler-audit, but outputs an HTML report and determines which gems are out-of-date as well.

## Getting started
To install Gemsurance, add
```ruby
gem 'gemsurance'
```
to your Gemfile and run bundle install.

Use gemsurance by running
```sh
bundle exec gemsurance [options]
```
from the directory containing the Gemfile whose gems you wish to check.

This will output an HTML file (named gemsurance_report.html by default) in the current directory containing a report of your gem status: which gems are out-of-date and which gems have reported vulnerabilities in the Ruby Advisory Database. The Ruby Advisory Database git repo will be checked out into tmp/vulnerabilities relative to the working directory.

![Example Gemsurance report](https://raw.github.com/appfolio/gemsurance/master/images/gemsurance_report.png)

Gems that are up-to-date are colored green and gems that are out-of-date but without reported vulnerabilities are colored yellow. Vulnerable gems are colored red, and information about the vulnerability and versions with a patch for the issue is displayed in the rightmost column.

Gemsurance exits with code 0 if there are no gems with reported vulnerabilities and code 1 if there are any such gems.

### Integration into a Rails RSpec suite
Running the gemsurance check as part of your RSpec test suite will cause an RSpec failure whenever a gem with a known vulnerability is detected in your application. This is incredibly useful if your application is tested regularly by a CI build. You can set this up by adding sample_spec/gemsurance_spec.rb to your RSpec tests.

### Command-line options
Command-line options to the gemsurance executable are as follows:
- --pre: Consider pre-release gem versions
- --output FILE: Output report to specified file
- --whitelist FILE: Read whitelist from file. Defaults to .gemsurance.yml
- --format FORMAT: Output report to specified format (html, csv, & yml available). Html by default.

The whitelist must be in the format
```yaml
---
nokogiri:
  CVE-2015-1819:
    - 1.5.9
    - 1.6.0
  OSVDB-101179:
    - 1.5.6
    - 1.6.0
```

## TODOs
- Support Git versions of gems
- Formatting as JSON

## Contributing
Contributions are always welcome. Please fork the repo and create a pull request or create an issue.

## Acknowledgements
Thanks to Bundler and the Ruby Advisory Database, upon which Gemsurance is based.

## License
MIT License.
