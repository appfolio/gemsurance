# Gemsurance: Insurance for your Gems

Gemsurance is a tool for monitoring if any of your Ruby Gems are out-of-date or vulnerable. It uses [Bundler](https://github.com/bundler/bundler) and the [Ruby Advisory Database](https://github.com/rubysec/ruby-advisory-db) to do so.

## Getting started
To install Gemsurance, add
```
gem 'gemsurance'
```
to your Gemfile and run bundle install.

The primary way of using Gemsurance is via the gemsurance executable. Once the gem has been installed, run gemsurance from the directory containing the Gemfile whose gems you wish to check.

This will create a file (named gemsurance_report.html by default) in the current directory containing a report of your gem status: which gems are out-of-date and which gems have reported vulnerabilities in the Ruby Advisory Database.

The executable exits with code 0 if there are no gems with reported vulnerabilities and code 1 if there are any such gems.

### Command-line options
Command-line options to the gemsurance executable are as follows:
- --pre: Consider pre-release gem versions


## Example Output
Currently, the only output option available is HTML. 
Here is an example report with no vulnerability warnings:

![Example Gemsurance report](https://raw.github.com/appfolio/gemsurance/master/images/gemsurance_report.png)

Gems that are up-to-date are colored green and gems that are out-of-date but without reported vulnerabilities are colored yellow.

Here is part of a report with a vulnerable gem:

![Example Gemsurance report with vulnerable gem](https://raw.github.com/appfolio/gemsurance/master/images/gemsurance_report_vulnerable.png)

The vulnerable gem is colored red, and information about the vulnerability and versions with a patch for the issue is displayed in the rightmost column.

## TODOs
- Add CSV formatter
- Support Git versions of gems

## Contributing
Contributions are always welcome. Please fork the repo and create a pull request or create an issue.

## Acknowledgements
Thanks to Bundler and the Ruby Advisory Database, upon which Gemsurance is based.

## License
MIT License.