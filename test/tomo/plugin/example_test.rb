require "test_helper"

class Tomo::Plugin::ExampleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Tomo::Plugin::Example::VERSION
  end
end
