class Tomo::Plugin::SidekiqTest < Tomo::Plugin::Sidekiq::Test
  def test_that_it_has_a_version_number
    refute_nil Tomo::Plugin::Sidekiq::VERSION
  end
end
