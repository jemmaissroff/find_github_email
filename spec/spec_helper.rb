# frozen_string_literal: true

require "bundler/setup"
require "find_github_email"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Stub out printing from specs
  config.before(:all) do
    #   @original_stdout = $stdout
    #     $stdout = File.open(File::NULL, "w")
  end

  config.before(:each) do
    stub_const(
      "FindGithubEmail::GithubAccessToken::ACCESS_TOKEN_FILE_PATH",
      "test_file"
    )
  end
end
