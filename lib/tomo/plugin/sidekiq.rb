require "tomo"
require "tomo/plugin/sidekiq/tasks"
require "tomo/plugin/sidekiq/version"

module Tomo
  module Plugin
    module Sidekiq
      extend Tomo::PluginDSL

      tasks Tomo::Plugin::Sidekiq::Tasks

      # rubocop:disable Metrics/LineLength
      defaults sidekiq_systemd_service: "sidekiq_%{application}.service",
               sidekiq_systemd_service_path: ".config/systemd/user/%{sidekiq_systemd_service}",
               sidekiq_systemd_service_template_path: File.expand_path("sidekiq/service.erb", __dir__)
      # rubocop:enable Metrics/LineLength
    end
  end
end