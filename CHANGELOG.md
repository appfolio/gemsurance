## 0.10.0
* Add support for Bundler 2.x (@saturnflyer)
* Drop support for Ruby < 2.4
## 0.9.0
* Updated way that YAML is outputted so the format is always valid (@bagmangood)
* Added support for --format csv (@bagmangood)
## 0.8.0
* Add the ability to whitelist vulnerabilities in particular gem versions with the --whitelist option (@paulwhite)
## 0.7.0
* Add --fail-outdated command-line option to exit with code 2 if any gems are outdated (@thomasbiddle)
## 0.6.0
* Support bundled gems in deployment mode (@bencolon).
## 0.5.0
* Set up Travis.
* Add test-unit dependency (needed for Ruby 2.2+) (@bencolon).
* Add public access to gem infos (@bencolon).
## 0.4.0
* Add YAML output formatter (@bencolon).
## 0.3.1
* Fix command-line options parsing (@bencolon).
## 0.3.0
* Display Gemfile gems in bold in the report.
## 0.2.0
* Add example RSpec spec.
* Add --output option to specify output filename.
* Add homepage, code, and docs links for gems in HTML report, if available.
## 0.1.4
* Remove date from gemspec.
## 0.1.3
* Handle unaffected versions of gems.
## 0.1.2
* Fix vulnerability styling in HTML report.
## 0.1.1
* Inline styles in HTML report.
## 0.1.0
* Initial version, with HTML-formatted report only.
