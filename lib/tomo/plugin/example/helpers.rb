module Tomo::Plugin::Example
  module Helpers
    # Defines a remote.shout helper
    def shout(*message, **run_opts)
      remote.run "echo", *message.map(&:upcase), **run_opts
    end
  end
end
