require "test_helper"

class Tomo::Plugin::Example::TasksTest < Minitest::Test
  def setup
    @tester = Tomo::Testing::MockPluginTester.new("example")
  end

  def test_hello
    @tester.run_task("example:hello")
    assert_equal('echo hello,\ world', @tester.executed_script)
  end
end
