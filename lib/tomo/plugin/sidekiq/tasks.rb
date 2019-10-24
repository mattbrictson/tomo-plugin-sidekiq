module Tomo::Plugin::Sidekiq
  class Tasks < Tomo::TaskLibrary
    # Defines a sidekiq:hello task
    def hello
      remote.run "echo", "hello, world"
    end
  end
end
