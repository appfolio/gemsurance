# Gemsurance: Insurance for your Gems

Gemsurance is a tool for monitoring if any of your Ruby Gems are out-of-date or vulnerable. It uses [Bundler](https://github.com/bundler/bundler) and the
[Ruby Advisory Database](https://github.com/rubysec/ruby-advisory-db) to do so.

### Installation and Usage
In the directory containing your Gemfile:

```
gem install gemsurance
gemsurance
```

This will create a file (named gemsurance_report.html by default) in the current directory containing a report of your
gem status.

### TODOs
- Add CSV formatter
- Support Git versions of gems

### Contributing
Contributions are always welcome. Please fork the repo and create a pull request or create an issue.

### Acknowledgements
Thanks to Bundler and the Ruby Advisory Database, upon which Gemsurance is based.