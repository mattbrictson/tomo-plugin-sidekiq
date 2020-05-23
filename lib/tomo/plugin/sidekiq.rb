require "tomo"
require_relative "sidekiq/tasks"
require_relative "sidekiq/version"

module Tomo::Plugin::Sidekiq
  extend Tomo::PluginDSL

  tasks Tomo::Plugin::Sidekiq::Tasks
  defaults sidekiq_systemd_service: "sidekiq_%{application}.service",
           sidekiq_systemd_service_path: ".config/systemd/user/%{sidekiq_systemd_service}",
           sidekiq_systemd_service_template_path: File.expand_path("sidekiq/service.erb", __dir__)
end
