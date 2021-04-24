# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ])

  SimpleCov.start do
    command_name "spec"
    add_filter "spec"
  end
end

require "bundler/setup"
require "strings-ansi"

module TestHelpers
  module Paths
    def gem_root
      ::File.dirname(__dir__)
    end

    def dir_path(*args)
      path = ::File.join(gem_root, *args)
      FileUtils.mkdir_p(path) unless ::File.exist?(path)
      ::File.realpath(path)
    end

    def fixtures_path(*args)
      ::File.expand_path(::File.join(dir_path("spec/fixtures"), *args))
    end
  end
end

RSpec.configure do |config|
  config.extend(TestHelpers::Paths)
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
