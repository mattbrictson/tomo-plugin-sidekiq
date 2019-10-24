# tomo plugin template

This is a GitHub template for creating [tomo](https://github.com/mattbrictson/tomo) plugins, which are packaged as Ruby gems.

Read the tomo tutorial [Publishing a Plugin](https://tomo-deploy.com/tutorials/publishing-a-plugin/) to get started. Then press [**Use this template**](https://github.com/mattbrictson/tomo-plugin/generate) to generate a project from this template. In the generated project, run this script to rename the gem to meet your needs:

```
$ ruby rename_template.rb
```

This template is based on `bundle gem` with some notable improvements:

- Travis CI _and_ Circle CI configuration
- Minitest, with minitest-reporters for nicely formatted test output
- Rubocop with a good set of configuration
- [release-drafter](https://github.com/apps/release-drafter) GitHub Action for automating release notes
- A `rake bump` task to keep your Ruby and Bundler dependencies up to date
- A nice README with badges ready to go (see below)

---

<!-- END FRONT MATTER -->

# tomo-plugin-example

[![Gem Version](https://badge.fury.io/rb/replace_with_gem_name.svg)](https://rubygems.org/gems/replace_with_gem_name)
[![Travis](https://img.shields.io/travis/mattbrictson/tomo-plugin.svg?label=travis)](https://travis-ci.org/mattbrictson/tomo-plugin)
[![Circle](https://circleci.com/gh/mattbrictson/tomo-plugin.svg?style=shield)](https://circleci.com/gh/mattbrictson/tomo-plugin)
[![Code Climate](https://codeclimate.com/github/mattbrictson/tomo-plugin/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/tomo-plugin)

This is a [tomo](https://github.com/mattbrictson/tomo) plugin that ... TODO: Description of this plugin goes here.

---

- [Installation](#installation)
- [Settings](#settings)
- [Tasks](#tasks)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Installation

Run:

```
$ gem install tomo-plugin-example
```

Or add it to your Gemfile:

```ruby
gem "tomo-plugin-example"
```

Then add the following to `.tomo/config.rb`:

```ruby
plugin "example"
```

## Settings

TODO: document plugin settings

| Name                  | Purpose | Default |
| --------------------- | ------- | ------- |
| `plugin_name_setting` | TODO    | `nil`   |

## Tasks

TODO: document plugin tasks

### example:task_name

TODO

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/mattbrictson/tomo-plugin/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
