# tomo-plugin-sidekiq

[![Gem Version](https://badge.fury.io/rb/tomo-plugin-sidekiq.svg)](https://rubygems.org/gems/tomo-plugin-sidekiq)
[![Travis](https://img.shields.io/travis/mattbrictson/tomo-plugin-sidekiq.svg?label=travis)](https://travis-ci.org/mattbrictson/tomo-plugin-sidekiq)
[![Circle](https://circleci.com/gh/mattbrictson/tomo-plugin-sidekiq.svg?style=shield)](https://circleci.com/gh/mattbrictson/tomo-plugin-sidekiq)
[![Code Climate](https://codeclimate.com/github/mattbrictson/tomo-plugin-sidekiq/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/tomo-plugin-sidekiq)

This is a [tomo](https://github.com/mattbrictson/tomo) plugin that provides tasks for managing [sidekiq](https://github.com/mperham/sidekiq) via [systemd](https://en.wikipedia.org/wiki/Systemd), based on the recommendations in the sidekiq documentation. This plugin assumes that you are also using the tomo `rbenv` and `env` plugins, and that you are using a systemd-based Linux distribution like Ubuntu 18 LTS.

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

### sidekiq:setup_systemd

Configures systemd to manage sidekiq. This means that sidekiq will automatically be restarted if it crashes, or if the host is rebooted. This task essentially does two things:

1. Installs a `sidekiq.service` systemd unit
1. Enables it using `systemctl --user enable`

Note that these units will be installed and run for the deploy user. You can use `:sidekiq_systemd_service_template_path` to provide your own template and customize how sidekiq and systemd are configured.

`sidekiq:setup_systemd` is intended for use as a [setup](https://tomo-deploy.com/commands/setup/) task. It must be run before sidekiq can be started during a deploy.

### sidekiq:restart

Gracefully restarts the sidekiq service via systemd, or starts it if it isn't running already. Equivalent to:

```
systemctl --user restart sidekiq.service
```

### sidekiq:start

Starts the sidekiq service via systemd, if it isn't running already. Equivalent to:

```
systemctl --user start sidekiq.service
```

### sidekiq:stop

Stops the sidekiq service via systemd. Equivalent to:

```
systemctl --user stop sidekiq.service
```

### sidekiq:status

Prints the status of the sidekiq systemd service. Equivalent to:

```
systemctl --user status sidekiq.service
```

### sidekiq:log

Uses `journalctl` (part of systemd) to view the log output of the sidekiq service. This task is intended for use as a [run](https://tomo-deploy.com/commands/run/) task and accepts command-line arguments. The arguments are passed through to the `journalctl` command. For example:

```
$ tomo run -- sidekiq:log -f
```

Will run this remote script:

```
journalctl -q --user-unit=sidekiq.service -f
```

## Recommendations

### Sidekiq configuration

Add a `config/sidekiq.yml` file to your application (i.e. checked into git) and use that to configure sidekiq, using environment variables as necessary. For example:

```yaml
---
:queues:
  - default
  - mailers
  - active_storage_analysis
  - active_storage_purge

:concurrency: <%= ENV.fetch("SIDEKIQ_CONCURRENCY", "1") %>
```

Now you can tune sidekiq for each environment by simply setting environment variables (e.g. using `tomo run env:set`), without hard-coding configuration in git or within systemd files.

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/mattbrictson/tomo-plugin-sidekiq/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
