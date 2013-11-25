# Gemsurance: Insurance for your Gems

Gemsurance is a tool for monitoring if any of your Ruby Gems are out-of-date or vulnerable. It uses [Bundler](https://github.com/bundler/bundler) and the [Ruby Advisory Database](https://github.com/rubysec/ruby-advisory-db) to do so.

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

### Command-line options
Command-line options to the gemsurance executable are as follows:
- --pre: Consider pre-release gem versions

## TODOs
- Add CSV formatter
- Support Git versions of gems

## Contributing
Contributions are always welcome. Please fork the repo and create a pull request or create an issue.

## Acknowledgements
Thanks to Bundler and the Ruby Advisory Database, upon which Gemsurance is based.

## License
MIT License.