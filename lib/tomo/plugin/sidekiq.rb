require "tomo"
require "tomo/plugin/sidekiq/helpers"
require "tomo/plugin/sidekiq/tasks"
require "tomo/plugin/sidekiq/version"

module Tomo
  module Plugin
    module Sidekiq
      extend Tomo::PluginDSL

      # TODO: initialize this plugin's settings with default values
      # defaults sidekiq_setting: "foo",
      #          sidekiq_another_setting: "bar"

      tasks Tomo::Plugin::Sidekiq::Tasks
      helpers Tomo::Plugin::Sidekiq::Helpers
    end
  end
end
