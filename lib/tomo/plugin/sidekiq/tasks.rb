module Tomo::Plugin::Sidekiq
  class Tasks < Tomo::TaskLibrary
    SystemdUnit = Struct.new(:name, :template, :path)

    # rubocop:disable Metrics/AbcSize
    def setup_systemd
      linger_must_be_enabled!

      remote.mkdir_p service.path.dirname
      remote.write template: service.template, to: service.path

      remote.run "systemctl --user daemon-reload"
      remote.run "systemctl", "--user", "enable", service.name
    end
    # rubocop:enable Metrics/AbcSize

    %i[reload restart start stop status].each do |action|
      define_method(action) do
        remote.run "systemctl", "--user", action, service.name
      end
    end

    def log
      remote.attach "journalctl", "-q",
                    raw("--user-unit=#{service.name.shellescape}"),
                    *settings[:run_args]
    end

    private

    def service
      SystemdUnit.new(
        settings[:sidekiq_systemd_service],
        paths.sidekiq_systemd_service_template,
        paths.sidekiq_systemd_service
      )
    end

    def linger_must_be_enabled!
      linger_users = remote.list_files(
        "/var/lib/systemd/linger", raise_on_error: false
      )
      return if dry_run? || linger_users.include?(remote.host.user)

      die <<~ERROR.strip
        Linger must be enabled for the #{remote.host.user} user in order for
        sidekiq to stay running in the background via systemd. Run the following
        command as root:

          loginctl enable-linger #{remote.host.user}
      ERROR
    end
  end
end
