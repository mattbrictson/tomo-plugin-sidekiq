# tomo-plugin-sidekiq

[![Gem Version](https://badge.fury.io/rb/tomo-plugin-sidekiq.svg)](https://rubygems.org/gems/tomo-plugin-sidekiq)
[![Travis](https://img.shields.io/travis/mattbrictson/tomo-plugin-sidekiq.svg?label=travis)](https://travis-ci.org/mattbrictson/tomo-plugin-sidekiq)
[![Circle](https://circleci.com/gh/mattbrictson/tomo-plugin-sidekiq.svg?style=shield)](https://circleci.com/gh/mattbrictson/tomo-plugin-sidekiq)
[![Code Climate](https://codeclimate.com/github/mattbrictson/tomo-plugin-sidekiq/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/tomo-plugin-sidekiq)

This is a [tomo](https://github.com/mattbrictson/tomo) plugin that provides tasks for managing [sidekiq](https://github.com/mperham/sidekiq) via [systemd](https://en.wikipedia.org/wiki/Systemd), based on the recommendations in the sidekiq documentation. This plugin assumes that you are also using `rbenv` and `env`, and that you are using a systemd-based Linux distribution like Ubuntu 18 LTS.

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
$ gem install tomo-plugin-sidekiq
```

Or add it to your Gemfile:

```ruby
gem "tomo-plugin-sidekiq"
```

Then add the following to `.tomo/config.rb`:

```ruby
plugin "sidekiq"

setup do
  # ...
  run "sidekiq:setup_systemd"
end

deploy do
  # ...
  # Place this task at *after* core:symlink_current
  run "sidekiq:restart"
end
```

### enable-linger

This plugin installs sidekiq as a user-level service using systemctl --user. This allows sidekiq to be installed, started, stopped, and restarted without a root user or sudo. However, when provisioning the host you must make sure to run the following command as root to allow the sidekiq process to continue running even after the tomo deploy user disconnects:

```
# run as root
$ loginctl enable-linger <DEPLOY_USER>
```

## Settings

| Name                  | Purpose |
| --------------------- | ------- |
| `sidekiq_systemd_service` | Name of the systemd unit that will be used to manage sidekiq <br>**Default:** `"sidekiq_%{application}.service"`   |
| `sidekiq_systemd_service_path` | Location where the systemd unit will be installed <br>**Default:** `".config/systemd/user/%{sidekiq_systemd_service}"`   |
| `sidekiq_systemd_service_template_path` | Local path to the ERB template that will be used to create the systemd unit <br>**Default:** [service.erb](https://github.com/mattbrictson/tomo-plugin-sidekiq/blob/master/lib/tomo/plugin/sidekiq/service.erb)   |

## Tasks

TODO: document plugin tasks

### sidekiq:task_name

TODO

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/mattbrictson/tomo-plugin-sidekiq/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
