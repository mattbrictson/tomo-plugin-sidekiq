require "test_helper"

class Tomo::Plugin::Sidekiq::TasksTest < Minitest::Test
  def setup
    @tester = Tomo::Testing::MockPluginTester.new("sidekiq")
  end

  def test_hello
    @tester.run_task("sidekiq:hello")
    assert_equal('echo hello,\ world', @tester.executed_script)
  end
end
